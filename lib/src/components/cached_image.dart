import 'package:cached_network_image/cached_network_image.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../design/motion.dart';
import '../design/tokens.dart';

/// Network image with a static `surfaceContainer` placeholder, a short
/// fade-in and a local Iconsax error glyph (no third-party fallbacks).
class CachedImageCustom extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  /// Logical width the image is displayed at, used to downscale decoding.
  /// Falls back to [width]. When both are null the image decodes at full size.
  final double? decodeWidth;

  /// Accessible description. When null the image is treated as decorative
  /// and excluded from semantics.
  final String? semanticLabel;

  /// Clips the image, placeholder and error box.
  final BorderRadius? borderRadius;

  /// Shows a person glyph instead of a film glyph when the image fails.
  final bool isPerson;

  const CachedImageCustom(
    this.imageUrl, {
    super.key,
    this.height,
    this.width,
    this.decodeWidth,
    this.semanticLabel,
    this.borderRadius,
    this.isPerson = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final motion = MNMotion.of(context);
    final logicalWidth = decodeWidth ?? width;
    final memCacheWidth = logicalWidth == null || !logicalWidth.isFinite
        ? null
        : (logicalWidth * MediaQuery.devicePixelRatioOf(context)).round();

    Widget box({Widget? child}) => Container(
          height: height,
          width: width,
          color: cs.surfaceContainer,
          alignment: AlignmentDirectional.center,
          child: child,
        );

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      memCacheWidth: memCacheWidth,
      fit: BoxFit.cover,
      // Spec section 9: fade-ins are `short`; fades stay on under Reduce
      // Motion. Low power skips them (one animation per image).
      fadeInDuration:
          motion.lowPower ? Duration.zero : motion.fade(MNDuration.short),
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => box(),
      errorWidget: (context, url, error) => box(
        child: Icon(
          isPerson ? IconsaxOutline.user : IconsaxOutline.video,
          color: cs.onSurfaceVariant,
        ),
      ),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return Semantics(
      image: semanticLabel != null,
      label: semanticLabel,
      excludeSemantics: true,
      child: image,
    );
  }
}
