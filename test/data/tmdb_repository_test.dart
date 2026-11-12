import 'dart:io' show HandshakeException;

import 'package:Movie_Night/src/data/tmdb_client.dart';
import 'package:Movie_Night/src/data/tmdb_disk_cache.dart';
import 'package:Movie_Night/src/data/tmdb_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _MemDisk implements TmdbDiskCache {
  _MemDisk(this.now);
  final DateTime Function() now;
  final Map<String, CachedBody> store = {};
  @override
  Future<CachedBody?> read(String key) async => store[key];
  @override
  Future<void> write(String key, String body) async =>
      store[key] = CachedBody(body, now());
  @override
  Future<void> clear() async => store.clear();
}

String _page(int page) => '{"page":$page,"results":[{"adult":false,'
    '"id":$page,"title":"t$page","media_type":"movie","genre_ids":[28],'
    '"popularity":1.5,"video":false,"vote_average":7.0,"vote_count":10}],'
    '"total_pages":5,"total_results":5}';

// Same shape as test/models/moviedetails_test.dart.
const _details = '{"adult":false,"backdrop_path":"/bd.jpg","budget":1,'
    '"genres":[],"homepage":"","id":603,"imdb_id":"tt0133093",'
    '"original_title":"The Matrix","overview":"x","popularity":85.5,'
    '"poster_path":"/p.jpg","release_date":"1999-03-30","revenue":1,'
    '"runtime":136,"status":"Released","tagline":"t","title":"The Matrix",'
    '"video":false,"vote_average":8.2,"vote_count":25000}';

void main() {
  late DateTime clock;
  late List<Uri> requests;
  late http.Response Function(Uri) respond;
  late _MemDisk disk;

  TmdbRepository repo({int feedPages = 5}) => TmdbRepository(
        client: TmdbClient(
          apiKey: 'k',
          sleep: (_) async {},
          httpClient: MockClient((req) async {
            requests.add(req.url);
            return respond(req.url);
          }),
        ),
        diskCache: disk,
        now: () => clock,
        feedPages: feedPages,
      );

  setUp(() {
    clock = DateTime(2026, 11, 7, 12);
    requests = [];
    disk = _MemDisk(() => clock);
    respond = (uri) {
      final page = uri.queryParameters['page'];
      if (page != null) return http.Response(_page(int.parse(page)), 200);
      if (uri.path.startsWith('/3/search/'))
        return http.Response(_page(1), 200);
      return http.Response(_details, 200);
    };
  });

  test('feed fetches N pages and merges results in page order', () async {
    final m = await repo().trending(false, 'en');
    expect(requests, hasLength(5));
    expect(m.results.map((r) => r.id), [1, 2, 3, 4, 5]);
    expect(m.totalResults, 5);
  });

  test('same request returns the identical Future and hits network once',
      () async {
    final r = repo();
    final a = r.details(603, false, 'en');
    final b = r.details(603, false, 'en');
    expect(identical(a, b), isTrue);
    await a;
    expect(identical(r.details(603, false, 'en'), a), isTrue);
    expect(requests, hasLength(1));
  });

  test('language is part of the cache key', () async {
    final r = repo();
    await r.details(603, false, 'en');
    await r.details(603, false, 'ar');
    expect(requests, hasLength(2));
  });

  test('fresh disk entry is served without network after memory expiry',
      () async {
    final r = repo();
    await r.details(603, false, 'en');
    clock = clock.add(const Duration(hours: 2)); // memory 1h, disk 24h
    await r.details(603, false, 'en');
    expect(requests, hasLength(1));
  });

  test('stale disk entry is served when offline', () async {
    await repo().details(603, false, 'en');
    clock = clock.add(const Duration(days: 2)); // past disk-fresh window
    respond = (_) => throw http.ClientException('offline');

    final r = repo(); // new instance: empty memory layer
    final m = await r.details(603, false, 'en');
    expect(m.id, 603);
  });

  test('stale disk entry is served on a TLS handshake failure', () async {
    await repo().details(603, false, 'en');
    clock = clock.add(const Duration(days: 2));
    respond = (_) => throw const HandshakeException('captive portal');
    final m = await repo().details(603, false, 'en');
    expect(m.id, 603);
  });

  test('stale fallback is not used for 404', () async {
    await repo().details(603, false, 'en');
    clock = clock.add(const Duration(days: 2));
    respond = (_) => http.Response('', 404);
    await expectLater(
        repo().details(603, false, 'en'),
        throwsA(isA<TmdbException>()
            .having((e) => e.kind, 'kind', TmdbErrorKind.notFound)));
  });

  test('failures are not cached in memory', () async {
    final r = repo();
    respond = (_) => http.Response('', 404);
    await expectLater(r.details(1, false, 'en'), throwsA(isA<TmdbException>()));
    respond = (_) => http.Response(_details, 200);
    expect((await r.details(1, false, 'en')).id, 603);
  });

  test('search is not persisted to disk', () async {
    await repo().searchMulti('matrix', 'en');
    expect(disk.store, isEmpty);
  });

  test('discover without genre omits language (legacy behaviour)', () async {
    await repo(feedPages: 1).discoverMovies(lang: 'ar');
    expect(requests.single.queryParameters.containsKey('language'), isFalse);
    await repo(feedPages: 1).discoverMovies(genreId: 28, lang: 'ar');
    expect(requests.last.queryParameters['language'], 'ar');
    expect(requests.last.queryParameters['with_genres'], '28');
  });

  group('series only (no talk, news, reality or soap)', () {
    // id 1 drama, 2 talk show, 3 news, 4 reality, 5 soap, 6 comedy + talk.
    String tvPage() => '{"page":1,"results":['
        '${[
          [1, 18],
          [2, 10767],
          [3, 10763],
          [4, 10764],
          [5, 10766],
          [6, 35, 10767],
        ].map((r) => '{"id":${r[0]},"name":"s${r[0]}","media_type":"tv",'
            '"genre_ids":${r.sublist(1)},"popularity":1.0,'
            '"vote_average":7.0,"vote_count":1}').join(',')}'
        '],"total_pages":1,"total_results":6}';

    setUp(() {
      respond = (uri) => http.Response(tvPage(), 200);
    });

    const without = '10763|10764|10766|10767';

    test('isSeries leaves out the four genres and keeps the rest', () {
      expect(TmdbRepository.isSeries([18, 10765]), isTrue);
      expect(TmdbRepository.isSeries(null), isTrue);
      expect(TmdbRepository.isSeries([35, 10767]), isFalse);
      expect(TmdbRepository.isSeries([10766]), isFalse);
    });

    test('trending series drops them; trending movies are untouched', () async {
      final tv = await repo(feedPages: 1).trending(true, 'en');
      expect(tv.results.map((r) => r.id), [1]);
      expect(tv.totalResults, 1);
      final movies = await repo(feedPages: 1).trending(false, 'en');
      expect(movies.results, hasLength(6));
    });

    test('popular series asks discover/tv without those genres', () async {
      final m = await repo(feedPages: 1).popular(true, 'en');
      final q = requests.single;
      expect(q.path, '/3/discover/tv');
      expect(q.queryParameters['without_genres'], without);
      expect(q.queryParameters['sort_by'], 'popularity.desc');
      expect(m.results.map((r) => r.id), [1]);
      await repo(feedPages: 1).popular(false, 'en');
      expect(requests.last.path, '/3/movie/popular');
    });

    test('egyptian series leave them out; egyptian movies do not', () async {
      await repo(feedPages: 1).egyptianTitles(true, 'en');
      expect(requests.last.queryParameters['without_genres'], without);
      await repo(feedPages: 1).egyptianTitles(false, 'en');
      expect(
          requests.last.queryParameters.containsKey('without_genres'), isFalse);
    });

    test('airing today: series with an episode out today', () async {
      final m = await repo().airingToday('en');
      final q = requests.single;
      expect(q.path, '/3/discover/tv');
      expect(q.queryParameters['air_date.gte'], '2026-11-07');
      expect(q.queryParameters['air_date.lte'], '2026-11-07');
      expect(q.queryParameters['without_genres'], without);
      expect(m.results.map((r) => r.id), [1]);
    });

    test('recommendations for a series are filtered, for a movie not',
        () async {
      expect(
          (await repo().recommendations(9, true, 'en')).results, hasLength(1));
      expect(
          (await repo().recommendations(9, false, 'en')).results, hasLength(6));
    });

    test('search drops them unless asked for everything', () async {
      final r = repo();
      expect((await r.searchMulti('x', 'en')).results.map((e) => e.id), [1]);
      expect((await r.searchMulti('x', 'en', seriesOnly: false)).results,
          hasLength(6));
    });

    test('an actor\'s series credits are filtered', () async {
      respond = (uri) => http.Response(
          '{"cast":[${[
            [1, 18],
            [2, 10767],
          ].map((r) => '{"adult":false,"genre_ids":[${r[1]}],"id":${r[0]},'
              '"popularity":1.0,"vote_average":7.0,"vote_count":1}').join(',')}],'
          '"crew":[{"adult":false,"genre_ids":[10763],"id":3,'
          '"popularity":1.0,"vote_average":7.0,"vote_count":1}],"id":7}',
          200);
      final k = await repo().personCredits(7, true, 'en');
      expect(k.cast.map((c) => c.id), [1]);
      expect(k.crew, isEmpty);
    });
  });

  test('cacheKey is order-independent and excludes the api key', () {
    expect(TmdbRepository.cacheKey('movie/1', {'b': '2', 'a': '1'}),
        'movie/1?a=1&b=2');
  });

  group('refresh', () {
    test('goes back to the network despite fresh memory and disk', () async {
      final r = repo(feedPages: 1);
      await r.trending(false, 'en');
      await r.trending(false, 'en'); // cached
      expect(requests, hasLength(1));

      await r.refresh(() => r.trending(false, 'en'));
      expect(requests, hasLength(2));
    });

    test('later normal calls reuse the refreshed result', () async {
      final r = repo(feedPages: 1);
      await r.trending(false, 'en');
      final refreshed = r.refresh(() => r.trending(false, 'en'));
      await refreshed;
      expect(identical(r.trending(false, 'en'), refreshed), isTrue);
      expect(requests, hasLength(2));
    });

    test('offline refresh falls back to the cached copy', () async {
      final r = repo(feedPages: 1);
      await r.trending(false, 'en');
      respond = (_) => throw http.ClientException('offline');
      final m = await r.refresh(() => r.trending(false, 'en'));
      expect(m.results.single.id, 1);
    });

    test('calls outside refresh keep using the cache', () async {
      final r = repo(feedPages: 1);
      await r.trending(false, 'en');
      await r.refresh(() => r.trending(false, 'en'));
      await r.popular(false, 'en'); // new key: one request
      await r.trending(false, 'en'); // cached again
      expect(requests, hasLength(3));
    });
  });
}
