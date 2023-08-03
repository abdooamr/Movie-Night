import 'package:flutter/material.dart';

class Square_Tile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const Square_Tile({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        ),
        child: Image.asset(
          imagePath,
          height: 60,
        ),
      ),
    );
  }
}
