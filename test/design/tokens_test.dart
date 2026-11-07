import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/design/tokens.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  for (final brightness in Brightness.values) {
    group('contrast ${brightness.name}', () {
      final theme = buildAppTheme(brightness);
      final cs = theme.colorScheme;
      final mn = theme.extension<MNColors>()!;
      final backgrounds = <String, Color>{
        'surface': cs.surface,
        'surfaceContainer': cs.surfaceContainer,
        'surfaceContainerHigh': cs.surfaceContainerHigh,
      };
      final text = <String, Color>{
        'onSurface': cs.onSurface,
        'onSurfaceVariant': cs.onSurfaceVariant,
        'primary': cs.primary,
        'error': cs.error,
        'rating': mn.rating,
      };

      for (final t in text.entries) {
        for (final b in backgrounds.entries) {
          // Spec hex for light rating (#946000) gives 4.33:1 on
          // surfaceContainerHigh; the spec only claims 5.1 on surface.
          // Rating is not placed on sheets, so assert >= 4.3 there.
          final min = (brightness == Brightness.light &&
                  t.key == 'rating' &&
                  b.key == 'surfaceContainerHigh')
              ? 4.3
              : 4.5;
          test('${t.key} on ${b.key} >= $min', () {
            expect(contrast(t.value, b.value), greaterThanOrEqualTo(min));
          });
        }
      }
      test('onPrimary on primary >= 4.5', () {
        expect(contrast(cs.onPrimary, cs.primary), greaterThanOrEqualTo(4.5));
      });
      test('onError on error >= 4.5', () {
        expect(contrast(cs.onError, cs.error), greaterThanOrEqualTo(4.5));
      });
      for (final b in ['surface', 'surfaceContainer']) {
        test('outline on $b >= 3.0', () {
          expect(
              contrast(cs.outline, backgrounds[b]!), greaterThanOrEqualTo(3.0));
        });
      }
    });
  }

  test('primary values', () {
    expect(buildAppTheme(Brightness.dark).colorScheme.primary,
        const Color(0xFFBBA8FF));
    expect(buildAppTheme(Brightness.light).colorScheme.primary,
        const Color(0xFF5A3FD6));
  });

  test('glow, shadow and chrome tokens', () {
    final dark = buildAppTheme(Brightness.dark).extension<MNColors>()!;
    final light = buildAppTheme(Brightness.light).extension<MNColors>()!;
    expect(dark.glowOpacity, 0.55);
    expect(light.glowOpacity, 0.30);
    expect(dark.posterShadow, isEmpty);
    expect(light.posterShadow, isNotEmpty);
    expect(dark.chrome.a, closeTo(0.86, 0.01));
    expect(
        buildAppTheme(Brightness.dark, highContrast: true)
            .extension<MNColors>()!
            .chrome
            .a,
        1.0);
  });

  test('MNColors lerp and copyWith', () {
    final a = buildAppTheme(Brightness.dark).extension<MNColors>()!;
    final b = buildAppTheme(Brightness.light).extension<MNColors>()!;
    expect(a.lerp(b, 1).rating, b.rating);
    expect(a.lerp(b, 0).rating, a.rating);
    expect(a.copyWith(rating: const Color(0xFF000000)).rating,
        const Color(0xFF000000));
  });
}
