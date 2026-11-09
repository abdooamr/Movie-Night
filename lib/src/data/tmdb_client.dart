import 'dart:async';
import 'dart:io' show TlsException;

import 'package:http/http.dart' as http;

/// What went wrong talking to TMDB, so the UI can tell "you're offline" apart
/// from "this title doesn't exist" without parsing message strings.
enum TmdbErrorKind {
  /// No connection / DNS failure / socket reset.
  offline,

  /// Request did not complete within [TmdbClient.timeout] (after retries).
  timeout,

  /// HTTP 401 — almost always a missing `--dart-define-from-file=env.json`.
  unauthorized,

  /// HTTP 404.
  notFound,

  /// HTTP 429.
  rateLimited,

  /// HTTP 5xx (after retries).
  server,

  /// Any other non-200 status.
  http,
}

class TmdbException implements Exception {
  const TmdbException(this.kind, this.message, {this.statusCode});

  final TmdbErrorKind kind;
  final String message;
  final int? statusCode;

  /// True for failures where a stale cached copy is better than nothing.
  bool get isTransient =>
      kind == TmdbErrorKind.offline ||
      kind == TmdbErrorKind.timeout ||
      kind == TmdbErrorKind.server ||
      kind == TmdbErrorKind.rateLimited;

  @override
  String toString() => statusCode == null
      ? 'TmdbException(${kind.name}): $message'
      : 'TmdbException(${kind.name}, $statusCode): $message';
}

/// The single HTTP entry point for TMDB.
///
/// - one shared [http.Client] (connection reuse instead of a socket per call)
/// - per-attempt [timeout]
/// - retry with exponential backoff on timeouts, connection errors and 5xx;
///   never on 4xx
/// - maps every failure to a [TmdbException]
class TmdbClient {
  TmdbClient({
    http.Client? httpClient,
    String? apiKey,
    this.timeout = const Duration(seconds: 15),
    this.maxRetries = 2,
    this.baseBackoff = const Duration(milliseconds: 500),
    Future<void> Function(Duration)? sleep,
  })  : _http = httpClient ?? http.Client(),
        _apiKey = apiKey ?? _envApiKey,
        _sleep = sleep ?? Future<void>.delayed;

  // TMDB key is supplied at build time, never committed.
  //   flutter run --dart-define-from-file=env.json
  // See env.example.json and README.md -> Configuration.
  static const String _envApiKey = String.fromEnvironment('TMDB_API_KEY');

  static const String host = 'api.themoviedb.org';
  static const String basePath = '/3/';

  final http.Client _http;
  final String _apiKey;
  final Future<void> Function(Duration) _sleep;

  final Duration timeout;

  /// Extra attempts after the first one (so `2` means up to 3 requests).
  final int maxRetries;
  final Duration baseBackoff;

  Uri uriFor(String path, [Map<String, String> query = const {}]) =>
      Uri.https(host, '$basePath$path', {'api_key': _apiKey, ...query});

  /// GETs `path` (relative to `/3/`) and returns the response body on 200.
  Future<String> get(String path, [Map<String, String> query = const {}]) async {
    final uri = uriFor(path, query);
    var attempt = 0;
    while (true) {
      try {
        final response = await _http.get(uri).timeout(timeout);
        if (response.statusCode == 200) return response.body;
        throw _forStatus(response.statusCode, path);
      } on TmdbException catch (e) {
        if (e.kind != TmdbErrorKind.server || attempt >= maxRetries) rethrow;
      } on TimeoutException {
        if (attempt >= maxRetries) {
          throw TmdbException(TmdbErrorKind.timeout, 'Timed out loading $path');
        }
      } on http.ClientException catch (e) {
        // http's IOClient wraps SocketException and HttpException in this.
        if (attempt >= maxRetries) {
          throw TmdbException(
              TmdbErrorKind.offline, 'Network error loading $path: ${e.message}');
        }
      } on TlsException catch (e) {
        // HandshakeException is *not* wrapped (e.g. a captive-portal Wi-Fi
        // intercepting TLS). Treat it as offline so the repository can
        // serve the cached copy.
        if (attempt >= maxRetries) {
          throw TmdbException(
              TmdbErrorKind.offline, 'TLS error loading $path: ${e.message}');
        }
      }
      await _sleep(baseBackoff * (1 << attempt));
      attempt++;
    }
  }

  static TmdbException _forStatus(int status, String path) {
    final TmdbErrorKind kind;
    if (status == 401) {
      kind = TmdbErrorKind.unauthorized;
    } else if (status == 404) {
      kind = TmdbErrorKind.notFound;
    } else if (status == 429) {
      kind = TmdbErrorKind.rateLimited;
    } else if (status >= 500) {
      kind = TmdbErrorKind.server;
    } else {
      kind = TmdbErrorKind.http;
    }
    return TmdbException(kind, 'HTTP $status loading $path', statusCode: status);
  }

  void close() => _http.close();
}
