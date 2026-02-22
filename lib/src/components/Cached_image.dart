import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CachedImageCustom extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  const CachedImageCustom(
    this.imageUrl, {
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
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
          child: const Center(
            child: Text(
              'No Image',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
