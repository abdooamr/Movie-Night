import 'package:flutter/material.dart';

/// Spacing scale (spec section 5).
class MNSpace {
  const MNSpace._();
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Corner radii. Pill shapes use [StadiumBorder].
class MNRadius {
  const MNRadius._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;

  /// Floating chrome (the iOS tab bar pill).
  static const double chrome = 28;
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
}

/// Fixed sizes.
class MNSize {
  const MNSize._();
  static const double minTap = 48;
  static const double buttonHeight = 50;
  static const double avatar = 72;

  /// Hairline stroke on chrome.
  static const double hairline = 0.5;
}

/// Motion durations (spec section 9).
class MNDuration {
  const MNDuration._();
  static const Duration micro = Duration(milliseconds: 100);
  static const Duration short = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 280);
  static const Duration long = Duration(milliseconds: 420);
}

/// Motion curves.
class MNCurves {
  const MNCurves._();
  static const Curve standard = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve exit = Cubic(0.3, 0.0, 1.0, 1.0);
}

/// Spring physics.
class MNSprings {
  const MNSprings._();

  /// Critically damped press-release.
  static const SpringDescription press =
      SpringDescription(mass: 1, stiffness: 600, damping: 49);

  /// About 8% overshoot, for the Like-heart pop.
  static const SpringDescription pop =
      SpringDescription(mass: 1, stiffness: 400, damping: 22);
}

/// Roles Material's [ColorScheme] does not cover (spec section 3).
@immutable
class MNColors extends ThemeExtension<MNColors> {
  const MNColors({
    required this.rating,
    required this.chrome,
    required this.chromeHairline,
    required this.scrim,
    required this.onScrim,
    required this.glowOpacity,
    required this.posterShadow,
  });

  /// Rating star and score only ("marquee").
  final Color rating;

  /// Glass material fill for tab bar and pinned chrome.
  final Color chrome;

  /// 0.5 px hairline drawn on chrome.
  final Color chromeHairline;

  /// Gradient under any text on imagery.
  final LinearGradient scrim;

  /// Text and icons over the [scrim]; light in both themes.
  final Color onScrim;

  /// Opacity of the spill glow.
  final double glowOpacity;

  /// Poster shadow; empty in dark.
  final List<BoxShadow> posterShadow;

  static const Color _scrimEnd = Color(0xCC000000);
  static const LinearGradient _scrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), _scrimEnd],
  );

  static const Color _onScrim = Color(0xFFF3F0F8);
  static const Color _darkSurface = Color(0xFF121117);
  static const Color _lightSurface = Color(0xFFFBFAFD);
  static const Color _darkOnSurface = Color(0xFFF3F0F8);
  static const Color _lightOnSurface = Color(0xFF17151D);

  factory MNColors.dark({bool highContrast = false}) => MNColors(
        rating: const Color(0xFFF5C04A),
        chrome:
            highContrast ? _darkSurface : _darkSurface.withValues(alpha: 0.86),
        chromeHairline: _darkOnSurface.withValues(alpha: 0.08),
        scrim: _scrim,
        onScrim: _onScrim,
        glowOpacity: 0.55,
        posterShadow: const [],
      );

  factory MNColors.light({bool highContrast = false}) => MNColors(
        rating: const Color(0xFF8A5800),
        chrome: highContrast
            ? _lightSurface
            : _lightSurface.withValues(alpha: 0.86),
        chromeHairline: _lightOnSurface.withValues(alpha: 0.08),
        scrim: _scrim,
        onScrim: _onScrim,
        glowOpacity: 0.30,
        posterShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      );

  static MNColors of(BuildContext context) =>
      Theme.of(context).extension<MNColors>()!;

  @override
  MNColors copyWith({
    Color? rating,
    Color? chrome,
    Color? chromeHairline,
    LinearGradient? scrim,
    Color? onScrim,
    double? glowOpacity,
    List<BoxShadow>? posterShadow,
  }) =>
      MNColors(
        rating: rating ?? this.rating,
        chrome: chrome ?? this.chrome,
        chromeHairline: chromeHairline ?? this.chromeHairline,
        scrim: scrim ?? this.scrim,
        onScrim: onScrim ?? this.onScrim,
        glowOpacity: glowOpacity ?? this.glowOpacity,
        posterShadow: posterShadow ?? this.posterShadow,
      );

  @override
  MNColors lerp(ThemeExtension<MNColors>? other, double t) {
    if (other is! MNColors) return this;
    return MNColors(
      rating: Color.lerp(rating, other.rating, t)!,
      chrome: Color.lerp(chrome, other.chrome, t)!,
      chromeHairline: Color.lerp(chromeHairline, other.chromeHairline, t)!,
      scrim: LinearGradient.lerp(scrim, other.scrim, t)!,
      onScrim: Color.lerp(onScrim, other.onScrim, t)!,
      glowOpacity: glowOpacity + (other.glowOpacity - glowOpacity) * t,
      posterShadow: BoxShadow.lerpList(posterShadow, other.posterShadow, t)!,
    );
  }
}
