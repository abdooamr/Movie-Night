import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/motion.dart';
import '../../design/tokens.dart';
import '../../utils/poster_size.dart';

/// Section skeleton for a poster rail: one [Shimmer] over a title bar and a
/// row of poster cards sized like the real ones. Static under Reduce Motion.
class movieListViewShimmerWidget extends StatelessWidget {
  const movieListViewShimmerWidget({
    super.key,
    this.baseColor,
    this.highlightColor,
  });

  /// Defaults to `surfaceContainerHigh`.
  final Color? baseColor;

  /// Defaults to `surfaceContainerHighest`.
  final Color? highlightColor;

  static const int _count = 6;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = baseColor ?? cs.surfaceContainerHigh;
    final size = PosterSize.of(context);
    final gutter = (size.itemExtent - size.width) / 2;
    Widget bar(double width, double height) => SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(color: base, borderRadius: MNRadius.smAll),
          ),
        );

    return ExcludeSemantics(
      child: Shimmer.fromColors(
        enabled: MNMotion.of(context).allowRichMotion,
        baseColor: base,
        highlightColor: highlightColor ?? cs.surfaceContainerHighest,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: MNSpace.lg,
                vertical: MNSpace.md,
              ),
              child: bar(size.width, MNSpace.xl),
            ),
            const SizedBox(height: MNSpace.sm),
            SizedBox(
              height: size.cardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemExtent: size.itemExtent,
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: MNSpace.lg - gutter,
                ),
                itemCount: _count,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: gutter),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.posterHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: base,
                            borderRadius: MNRadius.mdAll,
                          ),
                        ),
                      ),
                      const SizedBox(height: MNSpace.sm),
                      bar(size.width * 0.8, MNSpace.lg),
                      const SizedBox(height: MNSpace.xs),
                      bar(size.width * 0.5, MNSpace.md),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
