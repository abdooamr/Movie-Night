import 'package:Movie_Night/generated/l10n.dart';
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
  late final DropdownProvider dropdownProvider =
      Provider.of<DropdownProvider>(context, listen: false);

  // Movie feeds are fetched on first build (movie tab is the default).
  // TV feeds are `late final`, so they are only fetched the first time the TV
  // tab is shown; after that the cached Future is reused on every toggle.
  late final Future<Model> upcomingFuture =
      getUpcomingMovies(dropdownProvider.selectedValue);
  late final Future<Model> trendingFuture =
      getTrending(false, dropdownProvider.selectedValue);
  late final Future<Model> popularMoviesFuture =
      getPopular(false, dropdownProvider.selectedValue);
  late final Future<Model> EgyptionMovies =
      getEgyptionmovies(false, dropdownProvider.selectedValue);

  late final Future<Model> airingTodayFuture =
      getAiringToday(dropdownProvider.selectedValue);
  late final Future<Model> trendingtvshowFuture =
      getTrending(true, dropdownProvider.selectedValue);
  late final Future<Model> popularTvFuture =
      getPopular(true, dropdownProvider.selectedValue);
  late final Future<Model> Egyptionseries =
      getEgyptionmovies(true, dropdownProvider.selectedValue);

  bool isMovie = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Typeswitch(
          title1: S.of(context).tvswitch,
          title2: S.of(context).movieswitch,
          movie: isMovie,
          tvshow: !isMovie,
          onMovieSelected: () => setState(() => isMovie = true),
          onTvShowSelected: () => setState(() => isMovie = false),
        ),
        Home_page_listview(
          movie: isMovie,
          tvshow: !isMovie,
          upcomingFuture: isMovie ? upcomingFuture : null,
          trendingFuture: isMovie ? trendingFuture : null,
          popularMoviesFuture: isMovie ? popularMoviesFuture : null,
          EgyptionMovies: isMovie ? EgyptionMovies : null,
          airingTodayFuture: isMovie ? null : airingTodayFuture,
          trendingtvshowFuture: isMovie ? null : trendingtvshowFuture,
          popularTvFuture: isMovie ? null : popularTvFuture,
          Egyptionseries: isMovie ? null : Egyptionseries,
        ),
      ],
    );
  }
}
