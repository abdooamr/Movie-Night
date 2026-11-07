import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../design/tokens.dart';

/// "★ 7.3" with an optional "TMDB" caption. Read as "7.3 out of 10".
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.score, this.showSource = false});

  final double score;
  final bool showSource;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final value = score.toStringAsFixed(1);
    final labelLarge = text.labelLarge!;
    return Semantics(
      label: S.of(context).ratingOutOf10(value),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconsaxBold.star_1,
            color: MNColors.of(context).rating,
            size: MediaQuery.textScalerOf(context).scale(labelLarge.fontSize!),
          ),
          const SizedBox(width: MNSpace.xs),
          Text(value, style: labelLarge),
          if (showSource) ...[
            const SizedBox(width: MNSpace.xs),
            Text(
              S.of(context).tmdbLabel,
              style: text.labelMedium!
                  .copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
