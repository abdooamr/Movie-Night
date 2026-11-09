import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/tokens.dart';

/// Two-or-more way toggle: the iOS sliding segmented control on every
/// platform (a neutral track with a raised thumb), in the app's colours.
class SegmentedToggle<T extends Object> extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.expand = false,
  });

  final List<(T value, String label)> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  /// Fill the available width (equal segments) instead of hugging the labels.
  final bool expand;

  void _change(T value) {
    if (value == selected) return;
    HapticFeedback.selectionClick();
    onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final style = theme.textTheme.labelLarge!;
    final control = CupertinoSlidingSegmentedControl<T>(
      groupValue: selected,
      backgroundColor: cs.surfaceContainer,
      thumbColor: cs.surfaceContainerHighest,
      padding: const EdgeInsetsDirectional.all(MNSpace.xxs),
      children: {
        for (final (value, label) in segments)
          value: Semantics(
            button: true,
            selected: value == selected,
            child: ConstrainedBox(
              // Each segment is a full-size touch target.
              constraints: const BoxConstraints(minHeight: MNSize.minTap),
              child: Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: MNSpace.md,
                  ),
                  child: Text(
                    label,
                    style: style.copyWith(
                      color: value == selected
                          ? cs.onSurface
                          : cs.onSurfaceVariant,
                    ),
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
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: MNSize.minTap),
      child: expand ? SizedBox(width: double.infinity, child: control) : control,
    );
  }
}
