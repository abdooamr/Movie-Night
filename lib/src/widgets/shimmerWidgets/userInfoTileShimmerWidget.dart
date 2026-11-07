import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoTileShimmerWidget extends StatelessWidget {
  const UserInfoTileShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListTile(
        tileColor: Theme.of(context).listTileTheme.tileColor,
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: baseColor,
            shape: BoxShape.circle,
          ),
        ),
        title: Container(
          height: 18,
          width: 160,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            height: 14,
            width: 220,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }
}
