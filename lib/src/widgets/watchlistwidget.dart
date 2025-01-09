import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:Movie_Night/src/components/stars.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/pages/UI/detail_page.dart';
import 'package:Movie_Night/src/Animation/CustomNavigationAnimation.dart';
import 'package:flutter/material.dart';

import 'package:Movie_Night/src/utils/utils.dart';

class bookmarkwidget extends StatelessWidget {
  final MovieModel movieDetails;
  final bool isTvShow;

  bookmarkwidget({
    required this.movieDetails,
    required this.isTvShow,
  });

  @override
  Widget build(BuildContext context) {
    var genress = movieDetails.genres;
    return GestureDetector(
      onTap: () {
        PageTransitionBuilder.navigateWithCustomTransition(
          context,
          DetailPage(
            id: movieDetails.id,
            isTvShow: isTvShow,
          ),
        );
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => DetailPage(
        //         id: movieDetails.id,
        //         isTvShow: isTvShow,
        //       ),
        //     ));
      },
      child: Column(
        children: [
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150, // Adjust the width as per your requirement
                height: 230, // Adjust the height as per your requirement
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedImageCustom(
                    movieDetails.posterPath == null
                        ? 'images/placeholder.png'
                        : '$imageUrl${movieDetails.posterPath!}',
                  ),
                ),
              ),
              Container(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          isTvShow ? movieDetails.name! : movieDetails.title!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${movieDetails.voteAverage.toStringAsFixed(1)}  ",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        StarRating(movieDetails.voteAverage),
                      ],
                    ),
                    Wrap(
                      children: [
                        Text(
                          genress.map((genre) => genre.name).join(' , '),
                          style: Theme.of(context).textTheme.labelLarge!,
                        ),
                      ],
                    ),
                    Text(
                      movieDetails.overview,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.grey.shade400,
                          ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15)
        ],
      ),
    );
  }
}
