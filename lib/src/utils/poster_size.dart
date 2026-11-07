import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// Single source of truth for poster-card dimensions.
///
/// 170x240 on a typical phone (so the original layout is unchanged), scaling
/// down on narrow screens and up on tablets (>= 600 dp wide). The caption
/// height grows with the system text scale (never clamped above) so two-line
/// captions don't clip.
class PosterSize {
  PosterSize._(this.width, this.height, this.captionHeight, this.textScale);

  static const double aspect = 240 / 170;

  /// Width:height of a poster image in [PosterCard] (2:3).
  static const double posterAspect = 2 / 3;
  static const double tabletBreakpoint = 600;
  static const double _hPad = 3; // per-side padding in the horizontal lists

  final double width;
  final double height;

  /// Room for a two-line titleMedium title plus a one-line labelMedium
  /// subtitle at the current text scale.
  final double captionHeight;

  /// Effective system text scale (at least 1.0, no upper bound).
  final double textScale;

  /// At very large text, rails should stack vertically instead of scrolling
  /// horizontally.
  bool get stackRails => textScale >= 1.5;

  /// Width each list item occupies; use as `ListView.itemExtent`.
  double get itemExtent => width + _hPad * 2;

  /// Total height of a poster + caption row.
  double get listHeight => height + 15 + captionHeight + 5;

  /// Height of the 2:3 poster image in a [PosterCard] of [width].
  double get posterHeight => width / posterAspect;

  /// Total height of a `PosterCard` of [width]: image, gap and caption, plus
  /// one pixel of slack for sub-pixel rounding of text line metrics.
  double get cardHeight => posterHeight + MNSpace.sm + captionHeight + 1;

  factory PosterSize.of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final scaler = MediaQuery.textScalerOf(context);
    final scale = math.max(1.0, scaler.scale(1));
    final width =
        w >= tabletBreakpoint ? 200.0 : (w * 0.42).clamp(120.0, 170.0);
    final text = Theme.of(context).textTheme;
    double line(TextStyle? s) {
      final size = s?.fontSize ?? 14;
      return math.max(scale * size, scaler.scale(size)) * (s?.height ?? 1.2);
    }

    final caption = 2 * line(text.titleMedium) + line(text.labelMedium);
    return PosterSize._(width, width * aspect, caption, scale);
  }
}
