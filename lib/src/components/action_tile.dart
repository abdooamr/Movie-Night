import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../design/motion.dart';
import '../design/tokens.dart';

/// Maps 0..1 through [MNSprings.pop] so it overshoots slightly.
class _SpringCurve extends Curve {
  const _SpringCurve();

  static final SpringSimulation _sim =
      SpringSimulation(MNSprings.pop, 0, 1, 0);
  // Seconds the pop spring takes to settle, used to normalise t.
  static const double _settle = 0.5;

  @override
  double transformInternal(double t) => _sim.x(t * _settle);
}

/// Square, tonal icon-over-label action (Like, Watchlist, Share...).
class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  static const double _minSize = 72;

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final motion = MNMotion.of(context);
    final current = selected && selectedIcon != null ? selectedIcon! : icon;
    final fg = selected ? cs.onPrimaryContainer : cs.onSurface;

    return Semantics(
      button: true,
      toggled: selectedIcon != null ? selected : null,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: _minSize,
          minHeight: _minSize,
        ),
        child: Material(
          color: selected ? cs.primaryContainer : cs.surfaceContainer,
          borderRadius: MNRadius.mdAll,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: MNSpace.sm,
                vertical: MNSpace.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: motion(MNDuration.short),
                    switchInCurve: const _SpringCurve(),
                    transitionBuilder: (child, anim) => motion.allowScale
                        ? ScaleTransition(scale: anim, child: child)
                        : FadeTransition(opacity: anim, child: child),
                    child: Icon(current, key: ValueKey(current), color: fg),
                  ),
                  const SizedBox(height: MNSpace.xs),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: fg),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
