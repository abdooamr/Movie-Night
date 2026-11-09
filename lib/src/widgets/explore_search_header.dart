import 'dart:math' as math;

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// The Search tab's pinned header: a search-field launcher right under the
/// status bar, then the genre tabs. There is no visible title, so the
/// launcher row carries the page heading ([title]) for assistive tech.
class ExploreSearchHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const ExploreSearchHeader({
    super.key,
    required this.title,
    required this.hint,
    required this.tabs,
    required this.controller,
    required this.onSearch,
    required this.textScaler,
  });

  /// Page name, announced as a heading.
  final String title;

  /// Search field hint; also the launcher's button label.
  final String hint;

  /// Genre tab labels.
  final List<String> tabs;
  final TabController controller;

  /// Opens the search delegate.
  final VoidCallback onSearch;

  /// Sizes the header; pass `MediaQuery.textScalerOf(context)`.
  final TextScaler textScaler;

  /// Material's search bar height at default text size.
  static const double _fieldBase = 56;

  /// Search field height: 56 up to about 2x text, then growing with the
  /// hint's line height so the header's declared size always fits.
  static double fieldHeightFor(TextScaler scaler) =>
      math.max(_fieldBase, scaler.scale(24) + MNSpace.sm);

  /// Total header height.
  static double heightFor(TextScaler scaler) =>
      MNSpace.sm + fieldHeightFor(scaler) + MNSpace.sm + kTextTabBarHeight;

  @override
  Size get preferredSize => Size.fromHeight(heightFor(textScaler));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: MNSpace.lg,
            vertical: MNSpace.sm,
          ),
          child: Semantics(
            container: true,
            header: true,
            label: title,
            // A launcher for the search delegate: the field itself never
            // takes input, so it is one button to assistive tech.
            child: Semantics(
              container: true,
              button: true,
              label: hint,
              excludeSemantics: true,
              onTap: onSearch,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onSearch,
                child: IgnorePointer(
                  child: ExcludeFocus(
                    child: SizedBox(
                      height: fieldHeightFor(textScaler),
                      child: SearchBar(
                        hintText: hint,
                        leading: Icon(
                          IconsaxOutline.search_normal,
                          color: cs.onSurfaceVariant,
                        ),
                        elevation: const WidgetStatePropertyAll(0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        TabBar(
          controller: controller,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [for (final label in tabs) Tab(text: label)],
        ),
      ],
    );
  }
}
