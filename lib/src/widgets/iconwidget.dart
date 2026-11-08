import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// Neutral icon chip for settings rows (spec section 3): `surfaceContainerHigh`
/// fill with an `onSurfaceVariant` glyph. [destructive] tints the glyph with
/// `error`; only Delete Account uses it.
class Iconwidget extends StatelessWidget {
  final IconData icon;
  final bool destructive;

  const Iconwidget({super.key, required this.icon, this.destructive = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: Container(
        padding: const EdgeInsetsDirectional.all(MNSpace.sm),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: MNRadius.smAll,
        ),
        child: Icon(
          icon,
          color: destructive ? cs.error : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
