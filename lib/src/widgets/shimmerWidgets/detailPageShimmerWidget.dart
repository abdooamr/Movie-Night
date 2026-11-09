import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/motion.dart';
import '../../design/tokens.dart';

/// Placeholder for the detail screen while it loads (shown under a plain
/// `AppBar`): poster and info lines, the primary button, the action tiles
/// and the storyline. One shimmer; a static skeleton under Reduce Motion.
class detailPageShimmerWidget extends StatelessWidget {
  const detailPageShimmerWidget({super.key});

  static const double _posterWidth = 112;
  static const double _posterHeight = 168;
  static const double _tileHeight = 72;
  static const double _lineHeight = 14;
  static const double _titleHeight = 24;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = cs.surfaceContainerHigh;
    Widget block(double h, {double? w, BorderRadius r = MNRadius.smAll}) =>
        Container(
          height: h,
          width: w,
          decoration: BoxDecoration(color: base, borderRadius: r),
        );
    Widget tile() => Expanded(child: block(_tileHeight, r: MNRadius.mdAll));

    return ExcludeSemantics(
      child: Shimmer.fromColors(
        enabled: MNMotion.of(context).allowRichMotion,
        baseColor: base,
        highlightColor: cs.surfaceContainerHighest,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsetsDirectional.all(MNSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  block(_posterHeight, w: _posterWidth, r: MNRadius.mdAll),
                  const SizedBox(width: MNSpace.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        block(_titleHeight),
                        const SizedBox(height: MNSpace.md),
                        block(_lineHeight, w: 160),
                        const SizedBox(height: MNSpace.md),
                        block(_lineHeight, w: 80),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MNSpace.xl),
              block(MNSize.buttonHeight, r: MNRadius.mdAll),
              const SizedBox(height: MNSpace.md),
              Row(children: [
                tile(),
                const SizedBox(width: MNSpace.sm),
                tile(),
                const SizedBox(width: MNSpace.sm),
                tile(),
              ]),
              const SizedBox(height: MNSpace.xl),
              block(_titleHeight, w: 140),
              const SizedBox(height: MNSpace.md),
              block(_lineHeight),
              const SizedBox(height: MNSpace.sm),
              block(_lineHeight),
              const SizedBox(height: MNSpace.sm),
              block(_lineHeight, w: 240),
            ],
          ),
        ),
      ),
    );
  }
}
