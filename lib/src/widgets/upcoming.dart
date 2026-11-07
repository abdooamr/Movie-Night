import 'package:Movie_Night/src/utils/poster_size.dart';
import 'dart:ui';
import 'package:Movie_Night/src/pages/UI/showallmovies.dart';
import 'package:Movie_Night/src/widgets/shimmerWidgets/upcomingShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/pages/UI/detail_page.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:Movie_Night/src/widgets/carousel_slider.dart';
import '../../generated/l10n.dart';
import '../models/movie_model.dart';

class UpcomingMovies extends StatelessWidget {
  const UpcomingMovies({
    required this.future,
    required this.headlineText,
    required this.istvshow,
    Key? key,
  }) : super(key: key);

  final Future<Model> future;
  final String headlineText;
  final bool istvshow;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Model>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          final baseColor =
              isDark ? Colors.grey.shade800 : Colors.grey.shade300;
          final highlightColor =
              isDark ? Colors.grey.shade700 : Colors.grey.shade100;

          return upcomingShimmerWidget(
              baseColor: baseColor, highlightColor: highlightColor);
        } else if (snapshot.hasData) {
          final data = snapshot.data?.results;

          return Column(
            children: [
              Text(
                headlineText,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 3,
              ),
              MyCarouselSlider(
                itemCount: data!.length > 20
                    ? 21
                    : data.length + 1, // Adjust the itemCount
                itemBuilder: (context, index, realindex) {
                  if (index == 20) {
                    // Render the "See All" button at index 21
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => See_All(
                              future: future,
                              headlineText: headlineText,
                              istvshow: istvshow,
                            ), // Replace with your "See All" page widget
                          ),
                        );
                      },
                      child: Container(
                        width: PosterSize.of(context).width + 4.5,
                        height:
                            (PosterSize.of(context).width + 4.5) * 250 / 174.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors
                              .deepPurpleAccent, // Set your desired button color here
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white, // Set the icon color
                                size: 48,
                              ),
                              Text(
                                S.of(context).Seealloptions,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Render the regular movie item
                    return RepaintBoundary(
                        child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  isTvShow: headlineText.contains(
                                          S.of(context).mediatypemoviess)
                                      ? false
                                      : true,
                                  id: data[index].id,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              data[index].posterPath == null
                                  ? 'https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg'
                                  : '$imageUrl${data[index].posterPath!}',
                              width: PosterSize.of(context).width + 4.5,
                              height: (PosterSize.of(context).width + 4.5) *
                                  250 /
                                  174.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 70,
                              width: PosterSize.of(context).width + 15,
                              padding: const EdgeInsets.all(10),
                              color: Colors.black26,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index].title ?? data[index].name!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    getGenres(data[index].genreIds!),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ));
                  }
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                S.of(context).somethingwentwrong,
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return upcomingShimmerWidget(
              baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              highlightColor:
                  isDark ? Colors.grey.shade700 : Colors.grey.shade100);
        }
      },
    );
  }
}
