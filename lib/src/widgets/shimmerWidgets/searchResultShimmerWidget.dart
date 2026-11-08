import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/motion.dart';
import '../../design/tokens.dart';

/// Placeholder rows shown while search results load. Static under Reduce
/// Motion.
class searchResultShimmerWidget extends StatelessWidget {
  const searchResultShimmerWidget({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = cs.surfaceContainerHighest;
    final highlight = cs.surfaceContainerHigh;

    Widget block(double height, double width) => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(color: base, borderRadius: MNRadius.smAll),
        );

    return ExcludeSemantics(
      child: Shimmer.fromColors(
        enabled: !MNMotion.of(context).reduce,
        baseColor: base,
        highlightColor: highlight,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: MNSpace.lg, vertical: MNSpace.sm),
            child: Row(
              children: [
                block(60, 40),
                const SizedBox(width: MNSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      block(MNSpace.lg, MNSpace.xxxl * 3),
                      const SizedBox(height: MNSpace.sm),
                      block(MNSpace.md, MNSpace.xxxl * 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
