import 'dart:async';
import 'dart:collection';

import 'package:Movie_Night/src/data/tmdb_client.dart';
import 'package:Movie_Night/src/data/tmdb_disk_cache.dart';
import 'package:Movie_Night/src/models/Knownfor_model.dart';
import 'package:Movie_Night/src/models/cast_model.dart';
import 'package:Movie_Night/src/models/credit_model.dart';
import 'package:Movie_Night/src/models/global_review_model.dart';
import 'package:Movie_Night/src/models/movie_model.dart' as movie;
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/models/video_model.dart';
import 'package:Movie_Night/src/models/video_prov_model.dart';
import 'package:flutter/foundation.dart' show compute, visibleForTesting;

/// How long a response stays usable from each cache layer.
class CachePolicy {
  const CachePolicy({required this.memory, this.disk});

  /// TTL of the parsed object in memory.
  final Duration memory;

  /// Disk entries younger than this are served without touching the network.
  /// `null` = never persisted (e.g. search).
  final Duration? disk;

  /// Feed lists change a few times a day.
  static const feed =
      CachePolicy(memory: Duration(minutes: 30), disk: Duration(hours: 3));

  /// Per-title data (details, credits, videos...) rarely changes.
  static const detail =
      CachePolicy(memory: Duration(hours: 1), disk: Duration(hours: 24));

  /// Free-text search: memory only.
  static const search = CachePolicy(memory: Duration(minutes: 10));
}

class _MemEntry {
  _MemEntry(this.future, this.expiresAt);
  final Future<Object?> future;
  DateTime expiresAt;
}

typedef _Body = ({String body, bool stale});

/// Typed, cached access to TMDB.
///
/// Two cache layers:
/// 1. **Memory** — the parsed object's `Future`, keyed by request. The *same*
///    `Future` instance is returned to every caller while it is fresh, so a
///    `FutureBuilder` rebuilt with it does not reset to `waiting`, and
///    concurrent callers share one in-flight request. Failures are evicted.
/// 2. **Disk** ([TmdbDiskCache]) — raw bodies. Fresh entries skip the network;
///    on a transient failure (offline, timeout, 5xx, 429) a stale entry up to
///    [maxStale] old is served instead of an error.
class TmdbRepository {
  TmdbRepository({
    TmdbClient? client,
    TmdbDiskCache? diskCache,
    DateTime Function()? now,
    this.maxStale = const Duration(days: 7),
    this.maxMemoryEntries = 200,
    this.feedPages = defaultFeedPages,
  })  : _client = client ?? TmdbClient(),
        _disk = diskCache ?? const NoTmdbDiskCache(),
        _now = now ?? DateTime.now;

  static TmdbRepository? _instance;

  /// App-wide instance (shared HTTP client + Hive disk cache).
  static TmdbRepository get instance =>
      _instance ??= TmdbRepository(diskCache: HiveTmdbDiskCache());

  @visibleForTesting
  static set instance(TmdbRepository repo) => _instance = repo;

  /// Number of TMDB pages the feed methods merge (~20 results each).
  /// Deliberate per OPEN_QUESTIONS Q1(a): fetch ~100 results up front.
  static const int defaultFeedPages = 5;

  /// A stale-served result is retried after this, not after the full TTL,
  /// so the app picks fresh data up soon after connectivity returns.
  static const Duration staleRetry = Duration(minutes: 1);

  final TmdbClient _client;
  final TmdbDiskCache _disk;
  final DateTime Function() _now;
  final Duration maxStale;
  final int maxMemoryEntries;
  final int feedPages;

  final LinkedHashMap<String, _MemEntry> _memory =
      LinkedHashMap<String, _MemEntry>();

  // --------------------------------------------------------------- series

  /// TMDB genres of TV that is not a series in the app's sense: News, Reality,
  /// Soap and Talk. Every "series" list leaves out titles with any of them.
  static const Set<int> nonSeriesGenres = {10763, 10764, 10766, 10767};

  /// The same set as TMDB's `without_genres` parameter (OR-ed).
  static final String _withoutGenres =
      (nonSeriesGenres.toList()..sort()).join('|');

  /// Whether a TV title with these genres counts as a series.
  static bool isSeries(List<int>? genreIds) =>
      !(genreIds ?? const <int>[]).any(nonSeriesGenres.contains);

  static bool _keepResult(movie.Result r) =>
      r.mediaType != movie.MediaType.tv || isSeries(r.genreIds);

  static movie.Model _onlySeries(movie.Model m, {bool allTv = false}) {
    final kept = [
      for (final r in m.results)
        if (allTv ? isSeries(r.genreIds) : _keepResult(r)) r,
    ];
    return movie.Model(
      page: m.page,
      results: kept,
      totalPages: m.totalPages,
      totalResults: kept.length,
    );
  }

  static Future<movie.Model> _parseSeries(String body) async =>
      _onlySeries(await _parseModel(body), allTv: true);

  static Future<movie.Model> _parseSearch(String body) async =>
      _onlySeries(await _parseModel(body));

  // ---------------------------------------------------------------- feeds

  Future<movie.Model> upcomingMovies(String lang) =>
      _feed('movie/upcoming', {'language': lang});

  /// TMDB cannot filter trending lists, so series are filtered here.
  Future<movie.Model> trending(bool isTvShow, String lang) => isTvShow
      ? _feed('trending/tv/day', {'language': lang}, seriesOnly: true)
      : _feed('trending/movie/day', {'language': lang});

  /// Series come from discover/tv (tv/popular cannot leave genres out),
  /// sorted the same way.
  Future<movie.Model> popular(bool isTvShow, String lang) => isTvShow
      ? _feed(
          'discover/tv',
          {
            'language': lang,
            'sort_by': 'popularity.desc',
            'without_genres': _withoutGenres,
          },
          seriesOnly: true)
      : _feed('movie/popular', {'language': lang});

  /// Without [genreId] the request historically omitted `language`; kept.
  Future<movie.Model> discoverMovies(
          {int? genreId, int? pageCount, String? lang}) =>
      _feed(
        'discover/movie',
        {
          if (genreId != null) 'with_genres': '$genreId',
          if (genreId != null && lang != null) 'language': lang,
        },
        pages: pageCount ?? feedPages,
      );

  Future<movie.Model> egyptianTitles(bool isTvShow, String lang) => _feed(
        isTvShow ? 'discover/tv' : 'discover/movie',
        {
          'with_origin_country': 'EG',
          'language': lang,
          if (isTvShow) 'without_genres': _withoutGenres,
        },
        seriesOnly: isTvShow,
      );

  /// English-language series with an episode out today (local date), most
  /// popular first. tv/airing_today was mostly talk and news shows.
  Future<movie.Model> airingToday(String lang) {
    final d = _now();
    String two(int v) => v.toString().padLeft(2, '0');
    final today = '${d.year}-${two(d.month)}-${two(d.day)}';
    return _single(
      'discover/tv',
      {
        'air_date.gte': today,
        'air_date.lte': today,
        'with_original_language': 'en',
        'without_genres': _withoutGenres,
        'sort_by': 'popularity.desc',
        'language': lang,
      },
      _parseSeries,
      CachePolicy.feed,
    );
  }

  // --------------------------------------------------------------- titles

  Future<MovieModel> details(int id, bool isTvShow, String lang) => _single(
      isTvShow ? 'tv/$id' : 'movie/$id',
      {'language': lang},
      _sync(movieModelFromJson),
      CachePolicy.detail);

  Future<Credit> credits(int id, bool isTvShow, String lang) => _single(
      isTvShow ? 'tv/$id/credits' : 'movie/$id/credits',
      {'language': lang},
      _sync(creditFromJson),
      CachePolicy.detail);

  Future<movie.Model> recommendations(int id, bool isTvShow, String lang) =>
      _single(
          isTvShow ? 'tv/$id/recommendations' : 'movie/$id/recommendations',
          {'language': lang},
          isTvShow ? _parseSeries : _parseModel,
          CachePolicy.detail);

  Future<Review> reviews(int id, bool isTvShow, String lang) => _single(
      isTvShow ? 'tv/$id/reviews' : 'movie/$id/reviews',
      {'language': lang},
      _sync(reviewFromJson),
      CachePolicy.detail);

  Future<Video> videos(int id, bool isTvShow, String lang) => _single(
      isTvShow ? 'tv/$id/videos' : 'movie/$id/videos',
      {'append_to_response': 'videos', 'language': lang},
      _sync(videoFromJson),
      CachePolicy.detail);

  Future<Watchprovider?> watchProviders(int id, bool isTvShow, String lang) =>
      _single(
          isTvShow ? 'tv/$id/watch/providers' : 'movie/$id/watch/providers',
          {'append_to_response': 'videos', 'language': lang},
          _sync(watchproviderFromJson),
          CachePolicy.detail);

  // --------------------------------------------------------------- people

  Future<CastModel> person(int id, String lang) => _single('person/$id',
      {'language': lang}, _sync(castModelFromJson), CachePolicy.detail);

  /// An actor's series credits leave out talk-show guest spots and the like.
  Future<KnownFor> personCredits(int id, bool isTvShow, String lang) => _single(
          isTvShow ? 'person/$id/tv_credits' : 'person/$id/movie_credits',
          {'language': lang}, _sync((body) {
        final k = knownForFromJson(body);
        if (isTvShow) {
          k.cast.removeWhere((c) => !isSeries(c.genreIds));
          k.crew.removeWhere((c) => !isSeries(c.genreIds));
        }
        return k;
      }), CachePolicy.detail);

  // --------------------------------------------------------------- search

  /// Movies, series and people. [seriesOnly] false keeps every kind of TV
  /// (for looking up a title already saved, whatever it is).
  Future<movie.Model> searchMulti(String query, String lang,
          {bool seriesOnly = true}) =>
      _single('search/multi', {'query': query, 'language': lang},
          seriesOnly ? _parseSearch : _parseModel, CachePolicy.search,
          keySuffix: seriesOnly ? '' : '#all');

  Future<movie.Model> searchTv(String query, String lang) => _single(
      'search/tv',
      {'query': query, 'language': lang},
      _parseSeries,
      CachePolicy.search);

  // -------------------------------------------------------------- control

  /// Drops the memory layer (e.g. after a language change, or for tests).
  void clearMemory() => _memory.clear();

  /// Runs [fetch] with both caches bypassed, for pull-to-refresh: every
  /// request it makes goes to the network, and the results replace the
  /// cached ones. A transient failure still falls back to the cached copy.
  Future<T> refresh<T>(Future<T> Function() fetch) =>
      runZoned(fetch, zoneValues: {_refreshZoneKey: true});

  static final Object _refreshZoneKey = Object();

  static bool get _refreshing => Zone.current[_refreshZoneKey] == true;

  Future<void> clearAll() async {
    _memory.clear();
    await _disk.clear();
  }

  void close() => _client.close();

  // ------------------------------------------------------------ internals

  static Future<movie.Model> _parseModel(String body) =>
      compute(movie.modelFromJson, body);

  static Future<T> Function(String) _sync<T>(T Function(String) parse) =>
      (body) async => parse(body);

  @visibleForTesting
  static String cacheKey(String path, Map<String, String> query) {
    final keys = query.keys.toList()..sort();
    return keys.isEmpty
        ? path
        : '$path?${keys.map((k) => '$k=${query[k]}').join('&')}';
  }

  Future<T> _single<T>(
    String path,
    Map<String, String> query,
    Future<T> Function(String body) parse,
    CachePolicy policy, {
    String keySuffix = '',
  }) =>
      _memo(cacheKey(path, query) + keySuffix, policy.memory, () async {
        final r = await _body(path, query, policy);
        return (value: await parse(r.body), stale: r.stale);
      });

  /// Fetches pages `1..pages` concurrently and merges them in page order.
  /// [seriesOnly] drops non-series results (for lists TMDB cannot filter).
  Future<movie.Model> _feed(
    String path,
    Map<String, String> query, {
    int? pages,
    bool seriesOnly = false,
  }) {
    final n = pages ?? feedPages;
    return _memo('${cacheKey(path, query)}#pages=$n', CachePolicy.feed.memory,
        () async {
      final bodies = await Future.wait([
        for (int page = 1; page <= n; page++)
          _body(path, {...query, 'page': '$page'}, CachePolicy.feed),
      ]);
      final models = await Future.wait([
        for (final b in bodies)
          seriesOnly ? _parseSeries(b.body) : _parseModel(b.body),
      ]);
      final results = [for (final m in models) ...m.results];
      return (
        value: movie.Model(
          page: 1,
          results: results,
          totalPages: n,
          totalResults: results.length,
        ),
        stale: bodies.any((b) => b.stale),
      );
    });
  }

  Future<T> _memo<T>(
    String key,
    Duration ttl,
    Future<({T value, bool stale})> Function() load,
  ) {
    final now = _now();
    final hit = _memory.remove(key);
    if (hit != null && hit.expiresAt.isAfter(now) && !_refreshing) {
      _memory[key] = hit; // move to most-recently-used
      return hit.future as Future<T>;
    }

    late final _MemEntry entry;
    final future = load().then((r) {
      if (r.stale) entry.expiresAt = _now().add(staleRetry);
      return r.value;
    });
    entry = _MemEntry(future, now.add(ttl));
    _memory[key] = entry;
    while (_memory.length > maxMemoryEntries) {
      _memory.remove(_memory.keys.first);
    }

    // Never cache a failure. (This listener also marks the error handled
    // for this branch; the caller still receives it via `future`.)
    future.then<void>((_) {}, onError: (Object _) {
      if (identical(_memory[key], entry)) _memory.remove(key);
    });
    return future;
  }

  Future<_Body> _body(
    String path,
    Map<String, String> query,
    CachePolicy policy,
  ) async {
    final key = cacheKey(path, query);
    // Hive keys are limited to 255 ASCII chars.
    final useDisk = policy.disk != null &&
        key.length <= 255 &&
        key.codeUnits.every((c) => c < 128);

    CachedBody? cached;
    if (useDisk) {
      cached = await _disk.read(key);
      if (cached != null &&
          !_refreshing &&
          _now().difference(cached.storedAt) < policy.disk!) {
        return (body: cached.body, stale: false);
      }
    }

    try {
      final body = await _client.get(path, query);
      if (useDisk) unawaited(_disk.write(key, body));
      return (body: body, stale: false);
    } on TmdbException catch (e) {
      if (cached != null &&
          e.isTransient &&
          _now().difference(cached.storedAt) < maxStale) {
        return (body: cached.body, stale: true);
      }
      rethrow;
    }
  }
}
