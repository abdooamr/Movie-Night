import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../design/motion.dart';
import '../design/tokens.dart';

/// Glass for the floating functional layer only (the tab bar, the Home type
/// switch): a [MNColors.chrome] fill with a hairline edge. Never for content
/// (cards, rows, posters).
///
/// - iOS: a real backdrop blur under the fill (frosted glass).
/// - Android: a frosted tint, the same fill a little denser, without the
///   blur. Measured on the Galaxy A50 (docs/perf/home-scroll.md, Home v2):
///   the blur alone took Home from 7.5 to 17.8 ms of raster per frame, with
///   most frames over budget.
/// - High Contrast (the reduce-transparency proxy): opaque, no blur.
/// - Low power: no blur.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.borderRadius,
    required this.child,
    this.blurSigma = 24,
  });

  final BorderRadius borderRadius;
  final double blurSigma;
  final Widget child;

  /// Opacity of the fill when there is no blur behind it (the tint).
  static const double tintOpacity = 0.92;

  /// Benchmark hook: draw every glass surface opaque, without the blur.
  @visibleForTesting
  static bool debugForceOpaque = false;

  /// Whether the blur is drawn in this context.
  static bool blurs(BuildContext context) =>
      !debugForceOpaque &&
      Theme.of(context).platform == TargetPlatform.iOS &&
      !MediaQuery.highContrastOf(context) &&
      !MNMotion.of(context).lowPower;

  @override
  Widget build(BuildContext context) {
    final mn = MNColors.of(context);
    final blur = blurs(context);
    final opaque = debugForceOpaque || MediaQuery.highContrastOf(context);
    final fill = blur
        ? mn.chrome
        : mn.chrome.withValues(alpha: opaque ? 1 : tintOpacity);
    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: borderRadius,
        border: Border.all(color: mn.chromeHairline, width: MNSize.hairline),
      ),
      // Boundary on the child, not around the BackdropFilter (which would
      // isolate it from the content it blurs).
      child: RepaintBoundary(child: child),
    );
    if (blur) {
      surface = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: surface,
      );
    }
    return ClipRRect(borderRadius: borderRadius, child: surface);
  }
}
