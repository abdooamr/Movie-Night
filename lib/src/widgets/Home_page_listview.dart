import 'package:Movie_Night/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
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
              headlineText: S.of(context).upcomingwidget_title,
              future: upcomingFuture,
              istvshow: false,
            ),
          if (movie)
            MoviesListView(
                future: trendingFuture,
                headlineText: S.of(context).trendingmovieswidget_title,
                istvshow: false),
          if (movie)
            MoviesListView(
              future: popularMoviesFuture,
              headlineText: S.of(context).popularmovieswidget_title,
              istvshow: false,
            ),
          if (movie)
            MoviesListView(
                future: EgyptionMovies,
                headlineText: S.of(context).egyptmovieswidget_title,
                istvshow: false),
          if (tvshow)
            UpcomingMovies(
              future: airingTodayFuture,
              headlineText: S.of(context).airingtodaywidget_title,
              istvshow: true,
            ),
          if (tvshow)
            MoviesListView(
              future: trendingtvshowFuture,
              headlineText: S.of(context).trendingtvwidget_title,
              istvshow: true,
            ),
          if (tvshow)
            MoviesListView(
              future: popularTvFuture,
              headlineText: S.of(context).populartvwidget_title,
              istvshow: true,
            ),
          if (tvshow)
            MoviesListView(
              future: Egyptionseries,
              headlineText: S.of(context).egypttvwidget_title,
              istvshow: true,
            ),
          // MoviesListView(
          //     future: topRatedFuture, headlineText: 'Top Rated Movies'),
        ],
      ),
    );
  }
}
