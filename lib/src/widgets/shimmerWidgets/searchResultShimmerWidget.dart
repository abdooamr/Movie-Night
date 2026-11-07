import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Placeholder rows shown while search results load.
class searchResultShimmerWidget extends StatelessWidget {
  const searchResultShimmerWidget({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = dark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlight = dark ? Colors.grey.shade700 : Colors.grey.shade100;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, i) => ListTile(
          leading: CircleAvatar(backgroundColor: base),
          title: Container(
            height: 14,
            margin: const EdgeInsets.only(right: 80),
            decoration: BoxDecoration(
                color: base, borderRadius: BorderRadius.circular(4)),
          ),
          subtitle: Container(
            height: 12,
            margin: const EdgeInsets.only(top: 8, right: 140),
            decoration: BoxDecoration(
                color: base, borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ),
    );
  }
}
