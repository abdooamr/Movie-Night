import 'package:Movie_Night/src/widgets/shimmerWidgets/genreListViewShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:Movie_Night/src/pages/UI/detail_page.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import '../models/movie_model.dart';

class GenresListView extends StatelessWidget {
  const GenresListView({
    required this.future,
    Key? key,
    required this.headlineText,
    this.istvshow = true,
  }) : super(key: key);
  final String headlineText;
  final Future<Model> future;
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

          return genreListViewShimmerWidget(
              headlineText: headlineText,
              baseColor: baseColor,
              highlightColor: highlightColor);
        } else if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
          var data = snapshot.data?.results;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: (data!.length / 2).ceil(),
                    itemBuilder: (context, rowIndex) {
                      final startIndex = rowIndex * 2;
                      final endIndex = startIndex + 1;

                      return Row(
                        children: [
                          for (int index = startIndex;
                              index <= endIndex && index < data.length;
                              index++)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                              isTvShow: istvshow,
                                              data: snapshot.data!,
                                              index: index,
                                              id: data[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedImageCustom(
                                            data[index].posterPath != null
                                                ? 'https://image.tmdb.org/t/p/w500${data[index].posterPath}'
                                                : 'https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg',
                                            height: 240,
                                            width: 170,
                                          )),
                                    ),
                                    const SizedBox(height: 15),
                                    Container(
                                      width: 170,
                                      height: 50,
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[index].title ??
                                                data[index].name!,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          Text(
                                            data[index].genreIds!.isNotEmpty
                                                ? getGenres(
                                                    data[index].genreIds!)
                                                : '',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
