import 'package:hive_flutter/hive_flutter.dart';

class CachedBody {
  const CachedBody(this.body, this.storedAt);
  final String body;
  final DateTime storedAt;
}

/// Persistent store for raw TMDB response bodies, keyed by request.
abstract class TmdbDiskCache {
  Future<CachedBody?> read(String key);
  Future<void> write(String key, String body);
  Future<void> clear();
}

/// No-op cache, for tests and as a fallback if Hive can't open its boxes.
class NoTmdbDiskCache implements TmdbDiskCache {
  const NoTmdbDiskCache();
  @override
  Future<CachedBody?> read(String key) async => null;
  @override
  Future<void> write(String key, String body) async {}
  @override
  Future<void> clear() async {}
}

/// Hive-backed cache.
///
/// Bodies live in a [LazyBox] so they are not all held in RAM (a 5-page feed
/// is ~100 KB); a small regular box tracks write timestamps for freshness
/// checks and pruning. Requires `Hive.initFlutter()` — done in `main.dart`.
///
/// Any Hive failure degrades to "no cache"; the cache must never break the
/// network path.
class HiveTmdbDiskCache implements TmdbDiskCache {
  HiveTmdbDiskCache({
    this.maxEntries = 300,
    this.maxAge = const Duration(days: 7),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  static const String bodiesBox = 'tmdb_cache_bodies';
  static const String stampsBox = 'tmdb_cache_stamps';

  final int maxEntries;
  final Duration maxAge;
  final DateTime Function() _now;

  Future<(LazyBox<String>, Box<int>)?>? _boxes;

  Future<(LazyBox<String>, Box<int>)?> _open() => _boxes ??= () async {
        try {
          final bodies = await Hive.openLazyBox<String>(bodiesBox);
          final stamps = await Hive.openBox<int>(stampsBox);
          await _prune(bodies, stamps);
          return (bodies, stamps);
        } catch (_) {
          return null;
        }
      }();

  @override
  Future<CachedBody?> read(String key) async {
    try {
      final boxes = await _open();
      if (boxes == null) return null;
      final (bodies, stamps) = boxes;
      final stamp = stamps.get(key);
      if (stamp == null) return null;
      final body = await bodies.get(key);
      if (body == null) return null;
      return CachedBody(body, DateTime.fromMillisecondsSinceEpoch(stamp));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String key, String body) async {
    try {
      final boxes = await _open();
      if (boxes == null) return;
      final (bodies, stamps) = boxes;
      await bodies.put(key, body);
      await stamps.put(key, _now().millisecondsSinceEpoch);
      if (stamps.length > maxEntries + 50) await _prune(bodies, stamps);
    } catch (_) {
      // Ignore: caching is best-effort.
    }
  }

  @override
  Future<void> clear() async {
    final boxes = await _open();
    if (boxes == null) return;
    await boxes.$1.clear();
    await boxes.$2.clear();
  }

  /// Drops entries older than [maxAge], then the oldest beyond [maxEntries].
  Future<void> _prune(LazyBox<String> bodies, Box<int> stamps) async {
    final cutoff = _now().subtract(maxAge).millisecondsSinceEpoch;
    final entries = stamps.toMap().entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    final doomed = <dynamic>[
      for (final e in entries)
        if (e.value < cutoff) e.key,
    ];
    final keep = entries.length - doomed.length;
    if (keep > maxEntries) {
      doomed.addAll(entries
          .where((e) => e.value >= cutoff)
          .take(keep - maxEntries)
          .map((e) => e.key));
    }
    // Orphaned bodies (stamp write lost on a crash).
    for (final k in bodies.keys) {
      if (!stamps.containsKey(k)) doomed.add(k);
    }
    if (doomed.isEmpty) return;
    await bodies.deleteAll(doomed);
    await stamps.deleteAll(doomed);
  }
}
