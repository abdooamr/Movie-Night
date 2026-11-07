import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../design/tokens.dart';

/// Rail / section title (titleLarge, a semantic header) with an optional
/// trailing "See All" button and a chevron that follows text direction.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.lg),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          if (onSeeAll != null)
            TextButton.icon(
              onPressed: onSeeAll,
              iconAlignment: IconAlignment.end,
              icon: Icon(
                rtl ? IconsaxOutline.arrow_left_3 : IconsaxOutline.arrow_right_3,
              ),
              // NEEDS_STRING seeAll: "See All" (closest existing key).
              label: Text(S.of(context).Seealloptions),
            ),
        ],
      ),
    );
  }
}
