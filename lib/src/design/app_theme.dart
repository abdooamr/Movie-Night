import 'package:flutter/material.dart';

import 'tokens.dart';
import 'typography.dart';

ColorScheme _scheme(Brightness b, bool highContrast) {
  final dark = b == Brightness.dark;
  final onSurface = dark ? const Color(0xFFF3F0F8) : const Color(0xFF17151D);
  final onSurfaceVariant =
      dark ? const Color(0xFFABA6B8) : const Color(0xFF575264);
  final outline = dark ? const Color(0xFF7A748C) : const Color(0xFF7D778C);
  return ColorScheme(
    brightness: b,
    surface: dark ? const Color(0xFF121117) : const Color(0xFFFBFAFD),
    surfaceContainerLowest:
        dark ? const Color(0xFF121117) : const Color(0xFFFBFAFD),
    surfaceContainerLow:
        dark ? const Color(0xFF181620) : const Color(0xFFF6F4F9),
    surfaceContainer: dark ? const Color(0xFF1C1A23) : const Color(0xFFF2F0F6),
    surfaceContainerHigh:
        dark ? const Color(0xFF26232F) : const Color(0xFFE9E6F0),
    surfaceContainerHighest:
        dark ? const Color(0xFF302D3A) : const Color(0xFFE0DDE8),
    onSurface: onSurface,
    onSurfaceVariant: highContrast ? onSurface : onSurfaceVariant,
    outline: highContrast ? onSurfaceVariant : outline,
    outlineVariant: dark ? const Color(0xFF2E2B38) : const Color(0xFFE2DFE8),
    primary: dark ? const Color(0xFFBBA8FF) : const Color(0xFF5A3FD6),
    onPrimary: dark ? const Color(0xFF1B1235) : const Color(0xFFFFFFFF),
    primaryContainer: dark ? const Color(0xFF2C2350) : const Color(0xFFE6DEFF),
    onPrimaryContainer:
        dark ? const Color(0xFFE6DEFF) : const Color(0xFF1B1235),
    secondary: dark ? const Color(0xFFABA6B8) : const Color(0xFF575264),
    onSecondary: dark ? const Color(0xFF121117) : const Color(0xFFFFFFFF),
    secondaryContainer:
        dark ? const Color(0xFF2C2350) : const Color(0xFFE6DEFF),
    onSecondaryContainer:
        dark ? const Color(0xFFE6DEFF) : const Color(0xFF1B1235),
    error: dark ? const Color(0xFFFF8E84) : const Color(0xFFB3261E),
    onError: dark ? const Color(0xFF3B0A07) : const Color(0xFFFFFFFF),
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),
    surfaceTint: Colors.transparent,
  );
}

/// Builds the Screening Room theme (spec sections 3, 4, 5, 7, 9).
///
/// [boldText] emboldens the text theme before component themes are derived
/// from it, so buttons, app bars, list tiles etc. follow the OS Bold Text
/// setting too.
ThemeData buildAppTheme(
  Brightness brightness, {
  bool highContrast = false,
  bool boldText = false,
}) {
  final cs = _scheme(brightness, highContrast);
  final mn = brightness == Brightness.dark
      ? MNColors.dark(highContrast: highContrast)
      : MNColors.light(highContrast: highContrast);
  final plain = buildTextTheme(cs.onSurface);
  final text = boldText ? emboldenTextTheme(plain) : plain;
  const minTap = Size(MNSize.minTap, MNSize.minTap);
  // Controls are rounded rectangles, not capsules: capsule buttons, a pill
  // tab indicator and outlined pill toggles read as Material defaults.
  const control = RoundedRectangleBorder(borderRadius: MNRadius.mdAll);
  const textControl = RoundedRectangleBorder(borderRadius: MNRadius.smAll);

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: cs,
    scaffoldBackgroundColor: cs.surface,
    canvasColor: cs.surface,
    textTheme: text,
    primaryTextTheme: text,
    extensions: [mn],
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      // The iOS push: slide in from the side, swipe from the edge to go back.
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    }),
    // A chevron for Back, as on iOS (it mirrors itself in RTL).
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (_) =>
          const Icon(Icons.arrow_back_ios_new_rounded),
    ),
    searchBarTheme: SearchBarThemeData(
      shape: const WidgetStatePropertyAll(control),
      backgroundColor: WidgetStatePropertyAll(cs.surfaceContainer),
      elevation: const WidgetStatePropertyAll(0),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: control,
        minimumSize: const Size(MNSize.minTap, MNSize.buttonHeight),
        textStyle: text.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: control,
        minimumSize: minTap,
        textStyle: text.labelLarge,
        side: BorderSide(color: cs.outline),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: textControl,
        minimumSize: minTap,
        textStyle: text.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cs.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: MNRadius.mdAll,
        borderSide: BorderSide(color: cs.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: MNRadius.mdAll,
        borderSide: BorderSide(color: cs.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: MNRadius.mdAll,
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: MNRadius.mdAll,
        borderSide: BorderSide(color: cs.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: MNRadius.mdAll,
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
      hintStyle: text.bodyLarge!.copyWith(color: cs.onSurfaceVariant),
      labelStyle: text.bodyLarge!.copyWith(color: cs.onSurfaceVariant),
    ),
    cardTheme: CardThemeData(
      color: cs.surfaceContainer,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: MNRadius.mdAll),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: text.titleLarge,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: cs.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      // The selected tab is tinted (icon and label); no pill behind it.
      indicatorColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: 0,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? cs.primary
              : cs.onSurfaceVariant,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => text.labelMedium!.copyWith(
          color: states.contains(WidgetState.selected)
              ? cs.primary
              : cs.onSurfaceVariant,
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        shape: control,
        minimumSize: minTap,
        textStyle: text.labelLarge,
        selectedBackgroundColor: cs.primaryContainer,
        selectedForegroundColor: cs.onPrimaryContainer,
        foregroundColor: cs.onSurfaceVariant,
        side: BorderSide(color: cs.outline),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: cs.surfaceContainerHigh,
      contentTextStyle: text.bodyMedium,
      actionTextColor: cs.primary,
      shape: const RoundedRectangleBorder(borderRadius: MNRadius.mdAll),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: cs.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: MNRadius.lgAll),
      titleTextStyle: text.headlineSmall,
      contentTextStyle: text.bodyMedium,
    ),
    listTileTheme: ListTileThemeData(
      minVerticalPadding: MNSpace.sm,
      minTileHeight: MNSize.minTap,
      iconColor: cs.onSurfaceVariant,
      // No textColor: ListTile would paint it over the subtitle's muted colour.
      titleTextStyle: text.bodyLarge,
      subtitleTextStyle: text.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: cs.primary,
      unselectedLabelColor: cs.onSurfaceVariant,
      labelStyle: text.labelLarge,
      unselectedLabelStyle: text.labelLarge,
      indicatorColor: cs.primary,
      dividerColor: Colors.transparent,
    ),
  );

  // ThemeData merges the platform typography into textTheme, which would put
  // an explicit family (e.g. Roboto) on the system-font roles. copyWith keeps
  // our roles verbatim so they inherit the platform font.
  return base.copyWith(textTheme: text, primaryTextTheme: text);
}

final Map<(Brightness, bool), ThemeData> _boldThemes = {};

/// MaterialApp.builder helper: when the OS Bold Text setting is on, re-themes
/// [child] with an emboldened full theme (including component themes).
Widget applyAccessibilityTheme(BuildContext context, Widget child) {
  if (!MediaQuery.boldTextOf(context)) return child;
  final brightness = Theme.of(context).brightness;
  final highContrast = MediaQuery.highContrastOf(context);
  final data = _boldThemes.putIfAbsent(
    (brightness, highContrast),
    () => buildAppTheme(brightness, highContrast: highContrast, boldText: true),
  );
  return Theme(data: data, child: child);
}
