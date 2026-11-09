import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/motion.dart';
import '../../design/tokens.dart';
import '../../utils/poster_size.dart';
import '../genreslistview.dart' show posterGridDelegate;

/// Sliver of placeholder poster cards shown while a genre feed loads. Shimmers
/// unless Reduce Motion is on, then shows static blocks.
class genreListViewShimmerWidget extends StatelessWidget {
  const genreListViewShimmerWidget({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = cs.surfaceContainerHighest;
    final highlight = cs.surfaceContainerHigh;
    final animate = MNMotion.of(context).allowRichMotion;

    Widget block(double height, {double? width, BorderRadius? radius}) =>
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: base,
            borderRadius: radius ?? MNRadius.smAll,
          ),
        );

    return SliverLayoutBuilder(
      builder: (context, constraints) => SliverGrid.builder(
        gridDelegate:
            posterGridDelegate(context, constraints.crossAxisExtent),
        itemCount: itemCount,
        itemBuilder: (context, _) => ExcludeSemantics(
          child: Shimmer.fromColors(
            enabled: animate,
            baseColor: base,
            highlightColor: highlight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: PosterSize.posterAspect,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: base,
                      borderRadius: MNRadius.mdAll,
                    ),
                  ),
                ),
                const SizedBox(height: MNSpace.sm),
                block(MNSpace.lg, width: double.infinity),
                const SizedBox(height: MNSpace.xs),
                block(MNSpace.md, width: MNSpace.xxxl * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
