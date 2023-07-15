import 'package:Movie_Night/src/models/tvshow_model.dart';
import 'package:Movie_Night/src/widgets/Home_page_listview.dart';
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
      trendingtvshowFuture,
      popularMoviesFuture,
      topRatedFuture,
      EgyptionMovies,
      airingTodayFuture,
      Egyptionseries,
      popularTvFuture;
  bool movie = true;
  bool tvshow = false;

  @override
  void initState() {
    upcomingFuture = getUpcomingMovies();
    trendingFuture = getTrending(false);
    trendingtvshowFuture = getTrending(true);
    EgyptionMovies = getEgyptionmovies(false);
    Egyptionseries = getEgyptionmovies(true);
    popularMoviesFuture = getPopular(false);
    popularTvFuture = getPopular(true);
    topRatedFuture = getTopRatedMovies();
    airingTodayFuture = getAiringToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Typeswitch(
          movie: movie,
          tvshow: tvshow,
          onMovieSelected: () {
            setState(() {
              movie = true;
              tvshow = false;
            });
          },
          onTvShowSelected: () {
            setState(() {
              movie = false;
              tvshow = true;
            });
          },
        ),
        Home_page_listview(
            movie: movie,
            upcomingFuture: upcomingFuture,
            trendingFuture: trendingFuture,
            popularMoviesFuture: popularMoviesFuture,
            EgyptionMovies: EgyptionMovies,
            tvshow: tvshow,
            airingTodayFuture: airingTodayFuture,
            trendingtvshowFuture: trendingtvshowFuture,
            Egyptionseries: Egyptionseries,
            popularTvFuture: popularTvFuture),
      ],
    );
  }
}
