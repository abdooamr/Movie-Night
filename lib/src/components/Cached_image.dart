import 'package:Movie_Night/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CachedImageCustom extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  /// Logical width the image is displayed at, used to downscale decoding.
  /// Falls back to [width]. When both are null the image decodes at full size.
  final double? decodeWidth;

  const CachedImageCustom(
    this.imageUrl, {
    super.key,
    this.height,
    this.width,
    this.decodeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    final logicalWidth = decodeWidth ?? width;
    final memCacheWidth = logicalWidth == null || !logicalWidth.isFinite
        ? null
        : (logicalWidth * MediaQuery.devicePixelRatioOf(context)).round();

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      memCacheWidth: memCacheWidth,
      fit: BoxFit.cover,

      /// 🔹 Shimmer Placeholder
      placeholder: (context, url) {
        return Shimmer.fromColors(
          period: const Duration(milliseconds: 1500),
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },

      /// 🔹 Error Widget
      errorWidget: (context, url, error) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              S.of(context).noImage,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
