import 'package:flutter/material.dart';

import '../../components/glass.dart';
import '../../design/tokens.dart';

/// The app's tab bar (spec section 7, functional "chrome" layer): a floating
/// glass pill (radius 28, [GlassSurface]) 8 dp above the system bar, on
/// every platform (Home v2; Android had an opaque bar before). Opaque under
/// High Contrast and in low power.
///
/// Labels come from the theme's `navigationBarTheme` (labelMedium).
class ChromeBar extends StatelessWidget {
  const ChromeBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  /// Corner radius of the floating bar.
  static const double floatingRadius = MNRadius.chrome;

  /// Backdrop blur of the floating bar.
  static const double blurSigma = 24;

  /// Hairline drawn on the floating bar.
  static const double hairline = MNSize.hairline;

  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  /// Whether the bar floats over content (so the Scaffold should extend its
  /// body underneath). Always, since Home v2.
  static bool floats(BuildContext context) => true;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bar = MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
      ),
    );
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        MNSpace.lg,
        0,
        MNSpace.lg,
        bottomInset + MNSpace.sm,
      ),
      child: GlassSurface(
        borderRadius: BorderRadius.circular(floatingRadius),
        blurSigma: blurSigma,
        child: bar,
      ),
    );
  }
}
