import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class upcomingShimmerWidget extends StatelessWidget {
  const upcomingShimmerWidget({
    super.key,
    required this.baseColor,
    required this.highlightColor,
  });

  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Centered title shimmer
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: 200,
            height: 24,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),

        const SizedBox(height: 10),

        CarouselSlider.builder(
          itemCount: 3,
          itemBuilder: (context, index, realIndex) {
            return Shimmer.fromColors(
              period: const Duration(milliseconds: 1500),
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: 174.5,
                height: 250,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: highlightColor.withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            viewportFraction: .5, // SAME as your real slider
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            aspectRatio: 1.5,
          ),
        ),
      ],
    );
  }
}
