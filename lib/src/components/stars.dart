import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double voteAverage;
  static const int maxStars = 5;
  static const double maxRating = 10.0;

  StarRating(this.voteAverage);

  @override
  Widget build(BuildContext context) {
    double normalizedRating = (voteAverage / maxRating) * maxStars;
    int fullStars =
        normalizedRating.floor(); // Get the integer part (full stars)
    double decimalPart =
        normalizedRating - fullStars; // Get the decimal part (for half star)

    return Row(
      children: List.generate(maxStars, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.yellow);
        } else if (index == fullStars && decimalPart >= 0.5) {
          return Icon(Icons.star_half, color: Colors.yellow);
        } else {
          return Icon(Icons.star_border, color: Colors.yellow);
        }
      }),
    );
  }
}
