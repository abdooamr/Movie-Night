import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// A tab's top bar: its name as a large title on the leading edge, with any
/// [actions] on the same row. Pinned, and one row tall, so the content
/// starts right under it instead of below an empty collapsing bar. Grows
/// with the text size so the title is never clipped.
class LargeTitleBar extends StatelessWidget {
  const LargeTitleBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: MNSpace.lg,
      toolbarHeight: MediaQuery.textScalerOf(context)
          .scale(kToolbarHeight)
          .clamp(kToolbarHeight, double.infinity),
      title: Semantics(
        header: true,
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      actions: actions,
    );
  }
}
