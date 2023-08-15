import 'package:Movie_Night/generated/l10n.dart';
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
            child: Text(S.of(context).tvswitch,
                style: tvshow
                    ? Theme.of(context).textTheme.titleLarge
                    : TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      )
                // TextStyle(
                //   color: tvshow ? Colors.white : Colors.grey,
                //   fontSize: 18,
                //   fontWeight: FontWeight.w500,
                // ),
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
            child: Text(S.of(context).movieswitch,
                style: movie
                    ? Theme.of(context).textTheme.titleLarge
                    : TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      )),
          ),
        ],
      ),
    );
  }
}
