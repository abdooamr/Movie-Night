import 'package:Movie_Night/src/models/tvshow_model.dart';
import 'package:Movie_Night/src/widgets/switch.dart';
import 'package:Movie_Night/src/widgets/tvshow_listview.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/widgets/allwidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Model> upcomingFuture,
      trendingFuture,
      popularMoviesFuture,
      topRatedFuture;
  late Future<Tvshows> popularTvFuture;
  //late Future<Credit> creditsFuture;

  @override
  void initState() {
    upcomingFuture = getUpcomingMovies();
    trendingFuture = getTrendingMovies();
    popularMoviesFuture = getPopularMovies();
    popularTvFuture = getPopularTvShows();
    topRatedFuture = getTopRatedMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        //Typeswitch(),
        const SizedBox(
          height: 20,
        ),
        UpcomingMovies(
          future: upcomingFuture,
        ),
        const SizedBox(
          height: 20,
        ),
        MoviesListView(future: trendingFuture, headlineText: 'Trending'),
        MoviesListView(
            future: popularMoviesFuture, headlineText: 'Popular Movies'),
        //TvShowListView(headlineText: 'Popular TV Shows'),
        MoviesListView(
            future: topRatedFuture, headlineText: 'Top Rated Movies'),
      ],
    );
  }
}
