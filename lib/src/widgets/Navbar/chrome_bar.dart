import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../design/tokens.dart';

/// The app's tab bar (spec section 7, functional "chrome" layer).
///
/// - iOS: a floating glass pill (radius 28, blur sigma 24, [MNColors.chrome]
///   fill, hairline edge) 8 pt above the home indicator.
/// - Elsewhere: an opaque `surfaceContainer` [NavigationBar], no blur.
/// - High Contrast (the reduce-transparency proxy): opaque on both.
///
/// Labels come from the theme's `navigationBarTheme` (labelMedium).
class ChromeBar extends StatelessWidget {
  const ChromeBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  /// Corner radius of the floating iOS bar.
  static const double floatingRadius = 28;

  /// Backdrop blur of the floating iOS bar.
  static const double blurSigma = 24;

  /// Hairline drawn on the floating iOS bar.
  static const double hairline = 0.5;

  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  /// Whether the bar floats over content (so the Scaffold should extend its
  /// body underneath).
  static bool floats(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (!floats(context)) {
      return NavigationBar(
        backgroundColor: cs.surfaceContainer,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
      );
    }

    final mn = MNColors.of(context);
    final opaque = MediaQuery.highContrastOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    Widget bar = MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
      ),
    );
    bar = DecoratedBox(
      decoration: BoxDecoration(
        color: opaque ? mn.chrome.withValues(alpha: 1) : mn.chrome,
        borderRadius: BorderRadius.circular(floatingRadius),
        border: Border.all(color: mn.chromeHairline, width: hairline),
      ),
      // Boundary on the child, not around the BackdropFilter (which would
      // isolate it from the content it blurs).
      child: RepaintBoundary(child: bar),
    );
    if (!opaque) {
      bar = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: bar,
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        MNSpace.lg,
        0,
        MNSpace.lg,
        bottomInset + MNSpace.sm,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(floatingRadius),
        child: bar,
      ),
    );
  }
}
