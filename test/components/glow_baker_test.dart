import 'dart:typed_data';

import 'package:Movie_Night/src/components/glow_baker.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

// 1x1 transparent PNG.
final _png = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

/// How often a [_CountingImage] was actually loaded (decoded).
int _loads = 0;

class _CountingImage extends MemoryImage {
  const _CountingImage(super.bytes);

  @override
  ImageStreamCompleter loadImage(MemoryImage key, ImageDecoderCallback decode) {
    _loads++;
    return super.loadImage(key, decode);
  }
}

void main() {
  tearDown(debugClearGlowCache);

  testWidgets('bakes a 64x36 image', (tester) async {
    final img = await tester.runAsync(
      () => bakeGlow(MemoryImage(_png), ImageConfiguration.empty),
    );
    expect(img, isNotNull);
    expect(img!.width, GlowBake.width);
    expect(img.height, GlowBake.height);
    expect(GlowBake.width, 64);
    expect(GlowBake.height, 36);
    img.dispose();
  });

  testWidgets('same source hits the cache', (tester) async {
    _loads = 0;
    final source = _CountingImage(_png);
    await tester.runAsync(() async {
      (await bakeGlow(source, ImageConfiguration.empty))?.dispose();
      // Without the glow cache the second bake would have to decode again.
      PaintingBinding.instance.imageCache.clear();
      (await bakeGlow(source, ImageConfiguration.empty))?.dispose();
    });
    expect(_loads, 1);
  });

  testWidgets('peekGlow returns a clone only once baked', (tester) async {
    final source = MemoryImage(_png);
    expect(peekGlow(source), isNull);
    await tester.runAsync(
      () async => (await bakeGlow(source, ImageConfiguration.empty))?.dispose(),
    );
    final peeked = peekGlow(source);
    expect(peeked, isNotNull);
    expect(peeked!.width, GlowBake.width);
    peeked.dispose();
  });

  testWidgets('failed image returns null and is not cached', (tester) async {
    final bad = MemoryImage(Uint8List.fromList(const [1, 2, 3, 4]));
    final img = await tester.runAsync(
      () => bakeGlow(bad, ImageConfiguration.empty),
    );
    expect(img, isNull);
    expect(peekGlow(bad), isNull);
  });

  testWidgets('evicts the oldest entry past the cache size', (tester) async {
    final first = MemoryImage(_png);
    await tester.runAsync(() async {
      (await bakeGlow(first, ImageConfiguration.empty))?.dispose();
      for (var i = 0; i < GlowBake.cacheSize; i++) {
        final other = MemoryImage(Uint8List.fromList(_png));
        (await bakeGlow(other, ImageConfiguration.empty))?.dispose();
      }
    });
    expect(peekGlow(first), isNull);
  });
}
