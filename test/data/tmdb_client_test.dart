import 'dart:async';

import 'package:Movie_Night/src/data/tmdb_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

TmdbClient _client(MockClientHandler handler, {List<Duration>? sleeps}) =>
    TmdbClient(
      httpClient: MockClient(handler),
      apiKey: 'k',
      timeout: const Duration(milliseconds: 50),
      sleep: (d) async => sleeps?.add(d),
    );

void main() {
  test('builds /3/ URL with api_key and encoded query', () async {
    late Uri seen;
    final c = _client((req) async {
      seen = req.url;
      return http.Response('{}', 200);
    });
    await c.get('search/multi', {'query': 'a b&c', 'language': 'ar'});
    expect(seen.host, 'api.themoviedb.org');
    expect(seen.path, '/3/search/multi');
    expect(seen.queryParameters,
        {'api_key': 'k', 'query': 'a b&c', 'language': 'ar'});
  });

  test('retries 5xx with exponential backoff, then succeeds', () async {
    var calls = 0;
    final sleeps = <Duration>[];
    final c = _client((_) async {
      calls++;
      return calls < 3 ? http.Response('', 503) : http.Response('ok', 200);
    }, sleeps: sleeps);
    expect(await c.get('movie/1'), 'ok');
    expect(calls, 3);
    expect(sleeps, const [Duration(milliseconds: 500), Duration(seconds: 1)]);
  });

  test('gives up on 5xx after maxRetries with kind=server', () async {
    var calls = 0;
    final c = _client((_) async {
      calls++;
      return http.Response('', 500);
    });
    await expectLater(
        c.get('movie/1'),
        throwsA(isA<TmdbException>()
            .having((e) => e.kind, 'kind', TmdbErrorKind.server)
            .having((e) => e.statusCode, 'status', 500)));
    expect(calls, 3);
  });

  for (final (status, kind) in [
    (401, TmdbErrorKind.unauthorized),
    (404, TmdbErrorKind.notFound),
    (429, TmdbErrorKind.rateLimited),
    (400, TmdbErrorKind.http),
  ]) {
    test('does not retry $status; maps to ${kind.name}', () async {
      var calls = 0;
      final c = _client((_) async {
        calls++;
        return http.Response('', status);
      });
      await expectLater(c.get('movie/1'),
          throwsA(isA<TmdbException>().having((e) => e.kind, 'kind', kind)));
      expect(calls, 1);
    });
  }

  test('timeouts are retried then surface as kind=timeout', () async {
    var calls = 0;
    final c = _client((_) {
      calls++;
      return Completer<http.Response>().future; // never completes
    });
    await expectLater(
        c.get('movie/1'),
        throwsA(isA<TmdbException>()
            .having((e) => e.kind, 'kind', TmdbErrorKind.timeout)));
    expect(calls, 3);
  });

  test('connection errors surface as kind=offline', () async {
    final c = _client((_) async => throw http.ClientException('no route'));
    await expectLater(
        c.get('movie/1'),
        throwsA(isA<TmdbException>()
            .having((e) => e.kind, 'kind', TmdbErrorKind.offline)
            .having((e) => e.isTransient, 'isTransient', true)));
  });
}
