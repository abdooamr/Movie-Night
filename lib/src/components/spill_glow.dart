import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../design/motion.dart';
import '../design/tokens.dart';

/// The signature (spec section 8): a soft field of the film's own colour
/// spilling from the top of the screen behind [child].
///
/// A 16:9 band at the top holds [source] decoded at 200 px wide, blurred
/// (sigma 60), at [MNColors.glowOpacity], fading into `surface`. Cross-fades
/// over [MNDuration.long] when [source] changes (instant under Reduce
/// Motion). Off under High Contrast or with no source.
class SpillGlow extends StatelessWidget {
  const SpillGlow({super.key, required this.source, required this.child});

  final ImageProvider? source;
  final Widget child;

  static const int decodeWidth = 200;
  static const double blurSigma = 60;

  @override
  Widget build(BuildContext context) {
    final src = source;
    if (src == null || MediaQuery.highContrastOf(context)) return child;
    final surface = Theme.of(context).colorScheme.surface;
    final opacity = MNColors.of(context).glowOpacity;
    return Stack(
      children: [
        PositionedDirectional(
          top: 0,
          start: 0,
          end: 0,
          child: ExcludeSemantics(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: RepaintBoundary(
                child: ClipRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedSwitcher(
                        duration: MNMotion.of(context)(MNDuration.long),
                        switchInCurve: MNCurves.standard,
                        switchOutCurve: MNCurves.standard,
                        layoutBuilder: (current, previous) => Stack(
                          fit: StackFit.expand,
                          children: [...previous, if (current != null) current],
                        ),
                        child: _Glow(
                          key: ValueKey(src),
                          image: ResizeImage.resizeIfNeeded(
                              decodeWidth, null, src),
                          opacity: opacity,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.topCenter,
                            end: AlignmentDirectional.bottomCenter,
                            colors: [surface.withValues(alpha: 0), surface],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({super.key, required this.image, required this.opacity});

  final ImageProvider image;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: SpillGlow.blurSigma,
        sigmaY: SpillGlow.blurSigma,
        tileMode: TileMode.clamp,
      ),
      child: Image(
        image: image,
        fit: BoxFit.cover,
        opacity: AlwaysStoppedAnimation(opacity),
        excludeFromSemantics: true,
        gaplessPlayback: true,
        errorBuilder: (context, error, stack) => const SizedBox.shrink(),
      ),
    );
  }
}
