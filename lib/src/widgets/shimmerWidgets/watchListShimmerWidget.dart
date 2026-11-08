import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/motion.dart';
import '../../design/tokens.dart';

/// Skeleton for one Watchlist row (matches the row layout). Static under
/// Reduce Motion.
class WatchlistShimmerTile extends StatelessWidget {
  const WatchlistShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = cs.surfaceContainerHigh;
    final highlight = cs.surfaceContainerHighest;
    const thumbWidth = MNSize.avatar;

    Widget bar(double width, double height) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: highlight,
            borderRadius: MNRadius.smAll,
          ),
        );

    Widget content = Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: MNSpace.lg,
        vertical: MNSpace.sm,
      ),
      child: Row(
        children: [
          Container(
            width: thumbWidth,
            height: thumbWidth * 3 / 2,
            decoration: BoxDecoration(
              color: base,
              borderRadius: MNRadius.smAll,
            ),
          ),
          const SizedBox(width: MNSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bar(MNSize.avatar * 2, MNSpace.lg),
                const SizedBox(height: MNSpace.sm),
                bar(MNSize.avatar, MNSpace.md),
                const SizedBox(height: MNSpace.sm),
                bar(MNSize.avatar, MNSpace.md),
              ],
            ),
          ),
        ],
      ),
    );

    // Decorative placeholder.
    content = ExcludeSemantics(child: content);
    if (MNMotion.of(context).reduce) return content;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: content,
    );
  }
}
