// import 'package:Movie_Night/src/models/tvshow_model.dart';
// import 'package:Movie_Night/src/widgets/switch.dart';
// import 'package:flutter/material.dart';
// import 'package:Movie_Night/src/models/movie_model.dart';
// import 'package:Movie_Night/src/services/services.dart';
// import 'package:Movie_Night/src/widgets/allwidget.dart';

// class Tvshow_page extends StatefulWidget {
//   const Tvshow_page({Key? key}) : super(key: key);

//   @override
//   State<Tvshow_page> createState() => _Tvshow_pageState();
// }

// class _Tvshow_pageState extends State<Tvshow_page> {
//   late Future<Model> upcomingFuture,
//       trendingFuture,
//       popularMoviesFuture,
      
//       topRatedFuture;
      
//   //late Future<Credit> creditsFuture;

//   @override
//   void initState() {
//     upcomingFuture = getUpcomingMovies();
//     trendingFuture = getTrendingMovies();
//     popularMoviesFuture = getPopularMovies();
//     popularTvFuture = getPopularTvShows();
//     topRatedFuture = getTopRatedMovies();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         Typeswitch(),
//         const SizedBox(
//           height: 20,
//         ),
//         UpcomingMovies(
//           future: upcomingFuture,
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         MoviesListView(future: popularTvFuture, headlineText: 'Trending'),
//         MoviesListView(future: popularTvFuture, headlineText: 'Popular Movies'),
//         MoviesListView(
//             future: popularTvFuture, headlineText: 'Popular TV Shows'),
//         MoviesListView(
//             future: topRatedFuture, headlineText: 'Top Rated Movies'),
//       ],
//     );
//   }
// }
