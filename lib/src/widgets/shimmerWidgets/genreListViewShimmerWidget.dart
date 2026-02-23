import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class genreListViewShimmerWidget extends StatelessWidget {
  const genreListViewShimmerWidget({
    super.key,
    required this.headlineText,
    required this.baseColor,
    required this.highlightColor,
  });

  final String headlineText;
  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Headline shimmer (only if exists)
          if (headlineText != "")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: 200,
                    height: 22,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

          /// 🔹 Grid shimmer
          Expanded(
            child: ListView.builder(
              itemCount: 4, // number of shimmer rows
              itemBuilder: (context, rowIndex) {
                return Row(
                  children: List.generate(2, (colIndex) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Shimmer.fromColors(
                          period: const Duration(milliseconds: 1500),
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Poster shimmer
                              Container(
                                height: 240,
                                decoration: BoxDecoration(
                                  color: baseColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),

                              const SizedBox(height: 15),

                              /// Title + Genre shimmer
                              Container(
                                height: 50,
                                margin: const EdgeInsets.only(left: 5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 14,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: highlightColor.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    Container(
                                      height: 12,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: highlightColor.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
