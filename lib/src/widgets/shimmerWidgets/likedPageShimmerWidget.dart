import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class likedPageShimmerWidget extends StatelessWidget {
  const likedPageShimmerWidget({
    super.key,
    required this.baseColor,
    required this.highlightColor,
  });

  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              /// Poster shimmer
              Container(
                height: 300,
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  color: highlightColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              /// Title shimmer
              Container(
                height: 20,
                width: 150,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: highlightColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),

              /// Stars shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        color: highlightColor.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              /// Genres shimmer
              Container(
                height: 14,
                width: 120,
                decoration: BoxDecoration(
                  color: highlightColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),

              const Spacer(flex: 2),

              /// Delete button shimmer
              Container(
                height: 30,
                width: 30,
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
