import 'package:Movie_Night/src/models/tvshow_model.dart';
import 'package:Movie_Night/src/widgets/switch.dart';
import 'package:Movie_Night/src/widgets/tvshow_listview.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/widgets/allwidget.dart';

class Home_page_listview extends StatelessWidget {
  const Home_page_listview({
    super.key,
    required this.movie,
    required this.upcomingFuture,
    required this.trendingFuture,
    required this.popularMoviesFuture,
    required this.EgyptionMovies,
    required this.tvshow,
    required this.trendingtvshowFuture,
    required this.Egyptionseries,
    required this.popularTvFuture,
    required this.airingTodayFuture,
  });

  final bool movie;
  final Future<Model> upcomingFuture;
  final Future<Model> trendingFuture;
  final Future<Model> popularMoviesFuture;
  final Future<Model> EgyptionMovies;
  final bool tvshow;
  final Future<Model> trendingtvshowFuture;
  final Future<Model> airingTodayFuture;
  final Future<Model> Egyptionseries;
  final Future<Model> popularTvFuture;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          if (movie)
            UpcomingMovies(
              headlineText: 'Upcoming Movies',
              future: upcomingFuture,
            ),
          if (movie)
            MoviesListView(future: trendingFuture, headlineText: 'Trending'),
          if (movie)
            MoviesListView(
              future: popularMoviesFuture,
              headlineText: 'Popular Movies',
            ),
          if (movie)
            MoviesListView(
              future: EgyptionMovies,
              headlineText: 'Egyption Movies',
            ),
          if (tvshow)
            UpcomingMovies(
              future: airingTodayFuture,
              headlineText: 'Airing Today',
            ),
          if (tvshow)
            MoviesListView(
              future: trendingtvshowFuture,
              headlineText: 'Trending TV',
            ),
          if (tvshow)
            MoviesListView(
              future: Egyptionseries,
              headlineText: 'Egyption Tv Series',
            ),
          // MoviesListView(
          //     future: topRatedFuture, headlineText: 'Top Rated Movies'),
          if (tvshow)
            MoviesListView(
              future: popularTvFuture,
              headlineText: 'Popular TV',
            ),
        ],
      ),
    );
  }
}
