import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WatchlistShimmerTile extends StatelessWidget {
  const WatchlistShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              /// Poster shimmer
              Container(
                width: 90,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: highlightColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(width: 15),

              /// Text area shimmer
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 18,
                        width: 140,
                        decoration: BoxDecoration(
                          color: highlightColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 14,
                        width: 100,
                        decoration: BoxDecoration(
                          color: highlightColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 14,
                        width: 80,
                        decoration: BoxDecoration(
                          color: highlightColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              /// Delete shimmer
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: highlightColor.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
