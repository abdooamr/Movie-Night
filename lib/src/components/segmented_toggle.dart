import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/tokens.dart';

/// Two-or-more way toggle: sliding control on iOS, [SegmentedButton] elsewhere.
class SegmentedToggle<T extends Object> extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final List<(T value, String label)> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  void _change(T value) {
    if (value == selected) return;
    HapticFeedback.selectionClick();
    onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: MNSize.minTap),
      child: isIOS ? _ios(context) : _material(context),
    );
  }

  Widget _ios(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge;
    return CupertinoSlidingSegmentedControl<T>(
      groupValue: selected,
      padding: const EdgeInsetsDirectional.all(MNSpace.xs),
      children: {
        for (final (value, label) in segments)
          value: Semantics(
            selected: value == selected,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: MNSize.minTap - 2 * MNSpace.xs,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: MNSpace.md,
                  ),
                  child: Text(
                    label,
                    style: style,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
      },
      onValueChanged: (v) {
        if (v != null) _change(v);
      },
    );
  }

  Widget _material(BuildContext context) {
    return SegmentedButton<T>(
      showSelectedIcon: false,
      style: const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(0, MNSize.minTap)),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      segments: [
        for (final (value, label) in segments)
          ButtonSegment<T>(
            value: value,
            label: Semantics(
              selected: value == selected,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
      selected: {selected},
      onSelectionChanged: (s) => _change(s.first),
    );
  }
}
