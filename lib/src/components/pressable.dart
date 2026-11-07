import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../design/motion.dart';
import '../design/tokens.dart';

/// Press feedback for cards: scales to 0.97 on tap-down and springs back
/// ([MNSprings.press]) on release, with an [InkWell] highlight drawn over
/// [child]. Only the transform animates. Under Reduce Motion there is no
/// scale, just the ink.
///
/// This adds no accessible name: the [InkWell] exposes an unlabeled tap
/// action. Callers must provide one, e.g. wrap in
/// `Semantics(button: true, label: ..., excludeSemantics: true, onTap: ...)`
/// (as `PosterCard` does) or ensure [child] contains labelled text.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;

  static const double pressedScale = 0.97;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scale = AnimationController.unbounded(
    vsync: this,
    value: 1,
  );

  /// Read in [build] so gesture callbacks never look up inherited widgets.
  bool _allowScale = true;

  void _down() {
    if (!_allowScale) return;
    _scale.animateTo(
      PressableScale.pressedScale,
      duration: MNDuration.micro,
      curve: MNCurves.standard,
    );
  }

  void _release() {
    if (!_allowScale) {
      _scale.value = 1;
      return;
    }
    _scale.animateWith(SpringSimulation(
      MNSprings.press,
      _scale.value,
      1,
      _scale.velocity,
    ));
  }

  @override
  void dispose() {
    _scale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _allowScale = MNMotion.of(context).allowScale;
    final enabled = widget.onTap != null || widget.onLongPress != null;
    final content = Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: widget.borderRadius,
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              onTapDown: enabled ? (_) => _down() : null,
              onTapUp: enabled ? (_) => _release() : null,
              onTapCancel: enabled ? _release : null,
            ),
          ),
        ),
      ],
    );
    if (!_allowScale) return content;
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: content,
    );
  }
}
