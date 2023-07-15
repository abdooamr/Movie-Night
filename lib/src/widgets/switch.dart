import 'package:flutter/material.dart';

class Typeswitch extends StatelessWidget {
  final bool movie;
  final bool tvshow;
  final VoidCallback onMovieSelected;
  final VoidCallback onTvShowSelected;

  const Typeswitch({
    required this.movie,
    required this.tvshow,
    required this.onMovieSelected,
    required this.onTvShowSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: onTvShowSelected,
            child: Text(
              "TV Shows",
              style: TextStyle(
                color: tvshow ? Colors.white : Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            "   |   ",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: onMovieSelected,
            child: Text(
              "Movies",
              style: TextStyle(
                fontSize: 18,
                color: movie ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
