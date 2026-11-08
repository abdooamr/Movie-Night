import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/movie_model.dart';
import 'movies_listview.dart';
import 'upcoming.dart';

/// The Home feeds. [name] doubles as the section's Hero source key.
enum HomeFeed {
  upcoming,
  trending,
  popular,
  egyptian,
  airingToday,
  trendingTv,
  popularTv,
  egyptianTv;

  static const movieFeeds = [upcoming, trending, popular, egyptian];
  static const tvFeeds = [airingToday, trendingTv, popularTv, egyptianTv];

  bool get isTv => tvFeeds.contains(this);
}

/// Home's sections for one mode (Movies or TV): the hero carousel, then
/// three poster rails. A plain column; Home places it in a sliver.
class Home_page_listview extends StatelessWidget {
  const Home_page_listview({
    super.key,
    required this.movie,
    required this.futureOf,
    required this.onRetry,
    this.onFocusChanged,
  });

  /// Movies when true, TV shows otherwise.
  final bool movie;

  /// The (cached) future of a feed.
  final Future<Model> Function(HomeFeed feed) futureOf;

  /// Reloads one feed.
  final ValueChanged<HomeFeed> onRetry;

  /// The centred carousel item (spill-glow source).
  final ValueChanged<Result>? onFocusChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final feeds = movie ? HomeFeed.movieFeeds : HomeFeed.tvFeeds;
    String title(HomeFeed f) => switch (f) {
          HomeFeed.upcoming => s.upcomingwidget_title,
          HomeFeed.trending => s.trendingmovieswidget_title,
          HomeFeed.popular => s.popularmovieswidget_title,
          HomeFeed.egyptian => s.egyptmovieswidget_title,
          HomeFeed.airingToday => s.airingtodaywidget_title,
          HomeFeed.trendingTv => s.trendingtvwidget_title,
          HomeFeed.popularTv => s.populartvwidget_title,
          HomeFeed.egyptianTv => s.egypttvwidget_title,
        };

    final hero = feeds.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UpcomingMovies(
          future: futureOf(hero),
          headlineText: title(hero),
          istvshow: hero.isTv,
          heroSource: hero.name,
          onRetry: () => onRetry(hero),
          onFocusChanged: onFocusChanged,
        ),
        for (final feed in feeds.skip(1))
          MoviesListView(
            future: futureOf(feed),
            headlineText: title(feed),
            istvshow: feed.isTv,
            heroSource: feed.name,
            onRetry: () => onRetry(feed),
          ),
      ],
    );
  }
}
