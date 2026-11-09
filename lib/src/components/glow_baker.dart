import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Bake parameters for the spill glow (design doc section 8).
class GlowBake {
  const GlowBake._();

  /// Baked image size: 16:9, small enough that stretching it to the band is
  /// itself part of the blur.
  static const int width = 64;
  static const int height = 36;

  /// Blur at bake size. sigma 8 across 64 px is roughly sigma 60 across a
  /// ~480 dp band, the spec's original look.
  static const double sigma = 8;

  /// Baked sources kept in memory (about 9 KB each).
  static const int cacheSize = 24;
}

/// One cache slot. Waiters get their own clone the moment the bake lands, so
/// eviction can dispose [image] without racing anyone still awaiting it.
class _Entry {
  ui.Image? image;
  bool done = false;
  bool evicted = false;
  final List<Completer<ui.Image?>> waiters = [];
}

final LinkedHashMap<ImageProvider, _Entry> _cache =
    LinkedHashMap<ImageProvider, _Entry>();

/// The baked glow for [source] if it is already in the cache, as a clone the
/// caller must dispose. Never starts a bake.
ui.Image? peekGlow(ImageProvider source) {
  final entry = _cache[source];
  if (entry == null || !entry.done) return null;
  _touch(source, entry);
  return entry.image?.clone();
}

/// Bakes [source] into a [GlowBake.width] x [GlowBake.height] image: decoded
/// small, cover-cropped to 16:9 around the centre and blurred once. The
/// result is cached (LRU, [GlowBake.cacheSize] entries) by provider equality.
///
/// Completes with a clone the caller must dispose, or null if the image fails
/// (failures are not cached, so a later attempt retries).
Future<ui.Image?> bakeGlow(ImageProvider source, ImageConfiguration config) {
  final existing = _cache[source];
  if (existing != null) {
    _touch(source, existing);
    if (existing.done) return Future.value(existing.image?.clone());
    final waiter = Completer<ui.Image?>();
    existing.waiters.add(waiter);
    return waiter.future;
  }

  final entry = _Entry();
  final waiter = Completer<ui.Image?>();
  entry.waiters.add(waiter);
  _cache[source] = entry;
  _evictOverflow();

  _bake(source, config).catchError((Object _) => null).then((image) {
    entry
      ..image = image
      ..done = true;
    for (final w in entry.waiters) {
      w.complete(image?.clone());
    }
    entry.waiters.clear();
    if (image == null && identical(_cache[source], entry)) {
      _cache.remove(source);
    }
    if (entry.evicted) {
      entry.image?.dispose();
      entry.image = null;
    }
  });
  return waiter.future;
}

/// Empties the cache. Tests call it in `tearDown`.
@visibleForTesting
void debugClearGlowCache() {
  for (final entry in _cache.values) {
    _dispose(entry);
  }
  _cache.clear();
}

void _touch(ImageProvider source, _Entry entry) {
  _cache
    ..remove(source)
    ..[source] = entry;
}

void _evictOverflow() {
  while (_cache.length > GlowBake.cacheSize) {
    final oldest = _cache.keys.first;
    _dispose(_cache.remove(oldest)!);
  }
}

void _dispose(_Entry entry) {
  if (entry.done) {
    entry.image?.dispose();
    entry.image = null;
  } else {
    // Still baking: its waiters get clones first, then the bake disposes it.
    entry.evicted = true;
  }
}

Future<ui.Image?> _bake(ImageProvider source, ImageConfiguration config) async {
  final decoded = await _decode(
    ResizeImage.resizeIfNeeded(GlowBake.width, null, source),
    config,
  );
  if (decoded == null) return null;
  try {
    const out = Size(GlowBake.width + 0.0, GlowBake.height + 0.0);
    final w = decoded.width.toDouble();
    final h = decoded.height.toDouble();
    // Cover-crop the centre of the source to 16:9.
    final Rect src;
    if (w / h > out.aspectRatio) {
      final cropW = h * out.aspectRatio;
      src = Rect.fromLTWH((w - cropW) / 2, 0, cropW, h);
    } else {
      final cropH = w / out.aspectRatio;
      src = Rect.fromLTWH(0, (h - cropH) / 2, w, cropH);
    }
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawImageRect(
      decoded,
      src,
      Offset.zero & out,
      Paint()
        ..filterQuality = FilterQuality.medium
        ..imageFilter = ui.ImageFilter.blur(
          sigmaX: GlowBake.sigma,
          sigmaY: GlowBake.sigma,
          tileMode: TileMode.clamp,
        ),
    );
    final picture = recorder.endRecording();
    try {
      return await picture.toImage(GlowBake.width, GlowBake.height);
    } finally {
      picture.dispose();
    }
  } catch (_) {
    return null;
  } finally {
    decoded.dispose();
  }
}

/// First frame of [provider], or null on error.
Future<ui.Image?> _decode(ImageProvider provider, ImageConfiguration config) {
  final completer = Completer<ui.Image?>();
  final stream = provider.resolve(config);
  late final ImageStreamListener listener;
  listener = ImageStreamListener(
    (info, _) {
      if (!completer.isCompleted) completer.complete(info.image.clone());
      info.dispose();
      stream.removeListener(listener);
    },
    onError: (_, __) {
      if (!completer.isCompleted) completer.complete(null);
      stream.removeListener(listener);
    },
  );
  stream.addListener(listener);
  return completer.future;
}
