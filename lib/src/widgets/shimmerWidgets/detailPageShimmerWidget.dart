import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Placeholder for the full-page detail screen: backdrop, title, chips, text.
class detailPageShimmerWidget extends StatelessWidget {
  const detailPageShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = dark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlight = dark ? Colors.grey.shade700 : Colors.grey.shade100;
    Widget block(double h, {double? w, double r = 8}) => Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
              color: base, borderRadius: BorderRadius.circular(r)),
        );
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            block(280, r: 0),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  block(24, w: 220),
                  const SizedBox(height: 16),
                  Row(children: [
                    block(28, w: 80, r: 14),
                    const SizedBox(width: 8),
                    block(28, w: 80, r: 14),
                    const SizedBox(width: 8),
                    block(28, w: 80, r: 14),
                  ]),
                  const SizedBox(height: 24),
                  block(14),
                  const SizedBox(height: 10),
                  block(14),
                  const SizedBox(height: 10),
                  block(14, w: 240),
                  const SizedBox(height: 24),
                  block(160),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
