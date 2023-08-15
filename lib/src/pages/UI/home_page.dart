import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/widgets/Home_page_listview.dart';
import 'package:Movie_Night/src/widgets/switch.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:provider/provider.dart';

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
      EgyptionMovies,
      airingTodayFuture,
      Egyptionseries,
      popularTvFuture;
  bool movie = true;
  bool tvshow = false;
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    upcomingFuture = getUpcomingMovies(dropdownProvider.selectedValue);
    trendingFuture = getTrending(false, dropdownProvider.selectedValue);
    trendingtvshowFuture = getTrending(true, dropdownProvider.selectedValue);
    EgyptionMovies = getEgyptionmovies(false, dropdownProvider.selectedValue);
    Egyptionseries = getEgyptionmovies(true, dropdownProvider.selectedValue);
    popularMoviesFuture = getPopular(false, dropdownProvider.selectedValue);
    popularTvFuture = getPopular(true, dropdownProvider.selectedValue);
    airingTodayFuture = getAiringToday(dropdownProvider.selectedValue);
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
