import 'package:flutter/material.dart';

const String _display = 'poppins';

TextStyle _s(double size, double leading, FontWeight w, Color c,
        {bool poppins = false}) =>
    TextStyle(
      fontFamily: poppins ? _display : null,
      fontSize: size,
      height: leading / size,
      fontWeight: w,
      color: c,
    );

/// Type scale from spec section 4. Poppins for display roles only; the rest
/// use the platform system font.
TextTheme buildTextTheme(Color onSurface) => TextTheme(
      displayLarge: _s(57, 64, FontWeight.w700, onSurface, poppins: true),
      displayMedium: _s(45, 52, FontWeight.w700, onSurface, poppins: true),
      displaySmall: _s(34, 41, FontWeight.w700, onSurface, poppins: true),
      headlineLarge: _s(32, 40, FontWeight.w700, onSurface, poppins: true),
      headlineMedium: _s(28, 34, FontWeight.w700, onSurface, poppins: true),
      headlineSmall: _s(22, 28, FontWeight.w600, onSurface, poppins: true),
      titleLarge: _s(20, 25, FontWeight.w600, onSurface, poppins: true),
      titleSmall: _s(14, 20, FontWeight.w500, onSurface),
      titleMedium: _s(17, 22, FontWeight.w600, onSurface),
      bodyLarge: _s(17, 22, FontWeight.w400, onSurface),
      labelLarge: _s(16, 21, FontWeight.w600, onSurface),
      bodyMedium: _s(15, 20, FontWeight.w400, onSurface),
      bodySmall: _s(13, 18, FontWeight.w400, onSurface),
      labelMedium: _s(12, 16, FontWeight.w500, onSurface),
      labelSmall: _s(11, 13, FontWeight.w500, onSurface),
    );

FontWeight _bump(FontWeight? w) {
  final i = ((w ?? FontWeight.w400).index + 1).clamp(0, 8);
  return FontWeight.values[i];
}

/// Raises every weight one step (400 to 500 to 600 to 700 to 800), for
/// `MediaQuery.boldTextOf`.
TextTheme emboldenTextTheme(TextTheme t) {
  TextStyle? b(TextStyle? s) => s?.copyWith(fontWeight: _bump(s.fontWeight));
  return t.copyWith(
    displayLarge: b(t.displayLarge),
    displayMedium: b(t.displayMedium),
    displaySmall: b(t.displaySmall),
    headlineLarge: b(t.headlineLarge),
    headlineMedium: b(t.headlineMedium),
    headlineSmall: b(t.headlineSmall),
    titleLarge: b(t.titleLarge),
    titleMedium: b(t.titleMedium),
    titleSmall: b(t.titleSmall),
    bodyLarge: b(t.bodyLarge),
    bodyMedium: b(t.bodyMedium),
    bodySmall: b(t.bodySmall),
    labelLarge: b(t.labelLarge),
    labelMedium: b(t.labelMedium),
    labelSmall: b(t.labelSmall),
  );
}
