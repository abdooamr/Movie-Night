import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/motion.dart';
import '../../design/tokens.dart';

/// Skeleton for a Liked carousel card. Static under Reduce Motion.
class likedPageShimmerWidget extends StatelessWidget {
  const likedPageShimmerWidget({
    super.key,
    required this.baseColor,
    required this.highlightColor,
  });

  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    Widget bar(double width, double height) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: highlightColor,
            borderRadius: MNRadius.smAll,
          ),
        );

    Widget card = Container(
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: MNRadius.lgAll,
      ),
      padding: const EdgeInsetsDirectional.all(MNSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: highlightColor,
                borderRadius: MNRadius.mdAll,
              ),
            ),
          ),
          const SizedBox(height: MNSpace.sm),
          bar(MNSize.avatar * 2, MNSpace.lg),
          const SizedBox(height: MNSpace.sm),
          bar(MNSize.avatar, MNSpace.md),
        ],
      ),
    );
    card = ExcludeSemantics(child: card);
    if (!MNMotion.of(context).allowRichMotion) return card;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: card,
    );
  }
}
