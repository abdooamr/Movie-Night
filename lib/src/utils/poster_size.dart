import 'package:flutter/widgets.dart';

/// Single source of truth for poster-card dimensions.
///
/// 170x240 on a typical phone (so the original layout is unchanged), scaling
/// down on narrow screens and up on tablets (>= 600 dp wide). The caption
/// height grows with the system text scale so two-line captions don't clip.
class PosterSize {
  PosterSize._(this.width, this.height, this.captionHeight);

  static const double aspect = 240 / 170;
  static const double tabletBreakpoint = 600;
  static const double _hPad = 3; // per-side padding in the horizontal lists

  final double width;
  final double height;
  final double captionHeight;

  /// Width each list item occupies; use as `ListView.itemExtent`.
  double get itemExtent => width + _hPad * 2;

  /// Total height of a poster + caption row.
  double get listHeight => height + 15 + captionHeight + 5;

  factory PosterSize.of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.0);
    final width =
        w >= tabletBreakpoint ? 200.0 : (w * 0.42).clamp(120.0, 170.0);
    return PosterSize._(width, width * aspect, 50 * scale);
  }
}
