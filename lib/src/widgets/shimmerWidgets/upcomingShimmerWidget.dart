import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../design/motion.dart';
import '../../design/tokens.dart';
import '../upcoming.dart';

/// Section skeleton for the Home carousel: one [Shimmer] over a title bar
/// and the centred hero poster. Static under Reduce Motion.
class upcomingShimmerWidget extends StatelessWidget {
  const upcomingShimmerWidget({
    super.key,
    this.baseColor,
    this.highlightColor,
  });

  /// Defaults to `surfaceContainerHigh`.
  final Color? baseColor;

  /// Defaults to `surfaceContainerHighest`.
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = baseColor ?? cs.surfaceContainerHigh;
    final heroWidth = UpcomingMovies.posterWidthOf(context);
    final heroHeight = UpcomingMovies.posterHeightOf(context);

    return ExcludeSemantics(
      child: Shimmer.fromColors(
        enabled: !MNMotion.of(context).reduce,
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
              child: SizedBox(
                width: heroWidth,
                height: MNSpace.xl,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: MNRadius.smAll,
                  ),
                ),
              ),
            ),
            const SizedBox(height: MNSpace.sm),
            Center(
              child: SizedBox(
                width: heroWidth,
                height: heroHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: MNRadius.mdAll,
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
