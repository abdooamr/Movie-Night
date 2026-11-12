import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../design/motion.dart';
import '../design/tokens.dart';
import 'glow_baker.dart';

/// The signature (spec section 8): a soft field of the film's own colour
/// spilling from the top of the screen behind [child].
///
/// A 16:9 band at the top holds [source] baked once by [bakeGlow] into a
/// small blurred image (cached), stretched to the band at
/// [MNColors.glowOpacity] and fading into `surface`. No filter runs while
/// scrolling. Cross-fades over [MNDuration.long] when [source] changes
/// (instant under Reduce Motion). Off under High Contrast, with no source,
/// or when the image fails.
class SpillGlow extends StatelessWidget {
  const SpillGlow({super.key, required this.source, required this.child});

  final ImageProvider? source;
  final Widget child;

  static const int bakeWidth = GlowBake.width;
  static const int bakeHeight = GlowBake.height;
  static const double bakeSigma = GlowBake.sigma;

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
                        child: BakedGlow(
                          key: ValueKey(src),
                          source: src,
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

/// One baked glow ([bakeGlow]: a small blurred copy of [source]) at
/// [opacity]. Shows nothing until the bake lands (or if it fails).
class BakedGlow extends StatefulWidget {
  const BakedGlow({super.key, required this.source, required this.opacity});

  final ImageProvider source;
  final double opacity;

  @override
  State<BakedGlow> createState() => _BakedGlowState();
}

class _BakedGlowState extends State<BakedGlow> {
  /// This widget's own clone; disposed when replaced or unmounted.
  ui.Image? _image;
  ImageProvider? _requested;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolve();
  }

  @override
  void didUpdateWidget(BakedGlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) _resolve();
  }

  void _resolve() {
    final source = widget.source;
    if (source == _requested) return;
    _requested = source;
    final cached = peekGlow(source);
    if (cached != null) {
      _replace(cached);
      return;
    }
    _replace(null);
    bakeGlow(source, createLocalImageConfiguration(context)).then((image) {
      if (!mounted || _requested != source) {
        image?.dispose();
        return;
      }
      setState(() => _replace(image));
    });
  }

  void _replace(ui.Image? image) {
    _image?.dispose();
    _image = image;
  }

  @override
  void dispose() {
    _replace(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    if (image == null) return const SizedBox.shrink();
    return RawImage(
      image: image,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.medium,
      opacity: AlwaysStoppedAnimation(widget.opacity),
    );
  }
}
