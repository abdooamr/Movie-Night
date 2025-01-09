import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:Movie_Night/src/models/fakemovies.dart';
import 'package:Movie_Night/src/pages/UI/detail_page.dart';
import 'package:Movie_Night/src/pages/UI/showallmovies.dart';
import 'package:Movie_Night/src/Animation/CustomNavigationAnimation.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../models/movie_model.dart';

class MoviesListView extends StatelessWidget {
  const MoviesListView({
    required this.future,
    Key? key,
    required this.headlineText,
  }) : super(key: key);

  final String headlineText;
  final Future<Model> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Model>(
      future: future,
      builder: (context, snapshot) {
        var fakeData = FakeDataGenerator.generateFakeMovies(2);
        var data = snapshot.data?.results ?? fakeData;

        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Skeletonizer(
            effect: ShimmerEffect(),
            enabled: snapshot.connectionState == ConnectionState.waiting,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      headlineText,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    GestureDetector(
                      onTap: () {
                        PageTransitionBuilder.navigateWithCustomTransition(
                            context,
                            See_All(
                              future: future,
                              headlineText: headlineText,
                            ));
                      },
                      child: Text(
                        S.of(context).Seealloptions,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).highlightColor,
                            fontSize: 22),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 310,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length > 20 ? 20 : data.length,
                    itemBuilder: (context, index) {
                      print(data[index].posterPath);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                PageTransitionBuilder
                                    .navigateWithCustomTransition(
                                  context,
                                  DetailPage(
                                    isTvShow: headlineText.contains(S
                                                .of(context)
                                                .mediatypemoviess) ||
                                            data[index].mediaType ==
                                                MediaType.movie
                                        ? false
                                        : true,
                                    data: snapshot.data!,
                                    index: index,
                                    id: data[index].id,
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedImageCustom(
                                  height: 240,
                                  width: 170,
                                  '$imageUrl${data[index].posterPath}',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 170,
                              height: 50,
                              margin: const EdgeInsets.only(left: 5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index].title ?? data[index].name!,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    data[index].genreIds!.isNotEmpty
                                        ? getGenres(data[index].genreIds!)
                                        : '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}







// import 'package:Movie_Night/generated/l10n.dart';
// import 'package:Movie_Night/src/components/Cached_image.dart';
// import 'package:Movie_Night/src/pages/UI/detail_page.dart';
// import 'package:Movie_Night/src/pages/UI/showallmovies.dart';
// import 'package:Movie_Night/src/Animation/CustomNavigationAnimation.dart';
// import 'package:flutter/material.dart';
// import 'package:Movie_Night/src/utils/utils.dart';
// import '../models/movie_model.dart';

// class MoviesListView extends StatelessWidget {
//   const MoviesListView({
//     required this.future,
//     Key? key,
//     required this.headlineText,
//   }) : super(key: key);

//   final String headlineText;
//   final Future<Model> future;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Model>(
//       future: future,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Column(
//             children: [
//               Center(
//                 child: CircularProgressIndicator(
//                   color: Theme.of(context).splashColor,
//                   strokeWidth: 3,
//                 ),
//               ),
//               Center(
//                   child: SizedBox(
//                 height: 40,
//               ))
//             ],
//           );
//         } else if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
//           var data = snapshot.data?.results;
//           return Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       headlineText,
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         PageTransitionBuilder.navigateWithCustomTransition(
//                             context,
//                             See_All(
//                               future: future,
//                               headlineText: headlineText,
//                             ));
//                       },
//                       child: Text(
//                         S.of(context).Seealloptions,
//                         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                             color: Theme.of(context).highlightColor,
//                             fontSize: 22),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   height: 310,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: data!.length > 20 ? 20 : data.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 3),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 PageTransitionBuilder
//                                     .navigateWithCustomTransition(
//                                   context,
//                                   DetailPage(
//                                     isTvShow: headlineText.contains(S
//                                                 .of(context)
//                                                 .mediatypemoviess) ||
//                                             data[index].mediaType ==
//                                                 MediaType.movie
//                                         ? false
//                                         : true,
//                                     data: snapshot.data!,
//                                     index: index,
//                                     id: data[index].id,
//                                   ),
//                                 );
//                               },
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: CachedImageCustom(
//                                   height: 240,
//                                   width: 170,
//                                   '$imageUrl${data[index].posterPath}',
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             Container(
//                               width: 170,
//                               height: 50,
//                               margin: const EdgeInsets.only(left: 5),
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     data[index].title ?? data[index].name!,
//                                     overflow: TextOverflow.ellipsis,
//                                     style:
//                                         Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                   Text(
//                                     data[index].genreIds!.isNotEmpty
//                                         ? getGenres(data[index].genreIds!)
//                                         : '',
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       color: Colors.grey.shade300,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//     );
//   }
// }
