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
      if (uri.path.startsWith('/3/search/')) return http.Response(_page(1), 200);
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
