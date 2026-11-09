import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/motion.dart';
import '../../design/tokens.dart';

/// Loading placeholder shaped like [UserInfoHeader]. Static under Reduce
/// Motion.
class UserInfoTileShimmerWidget extends StatelessWidget {
  const UserInfoTileShimmerWidget({super.key});

  static const double _nameWidth = 160;
  static const double _emailWidth = 220;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = cs.surfaceContainerHigh;

    Widget bar(double width, double height) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: base, borderRadius: MNRadius.smAll),
        );

    final Widget placeholder = ExcludeSemantics(
      child: Row(
        children: [
          Container(
            width: MNSize.avatar,
            height: MNSize.avatar,
            decoration: BoxDecoration(color: base, shape: BoxShape.circle),
          ),
          const SizedBox(width: MNSpace.lg),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bar(_nameWidth, MNSpace.lg + MNSpace.xxs),
                const SizedBox(height: MNSpace.sm),
                bar(_emailWidth, MNSpace.md + MNSpace.xxs),
              ],
            ),
          ),
        ],
      ),
    );

    if (!MNMotion.of(context).allowRichMotion) return placeholder;
    return Shimmer.fromColors(
      period: MNDuration.long * 3.5,
      baseColor: base,
      highlightColor: cs.surfaceContainer,
      child: placeholder,
    );
  }
}
