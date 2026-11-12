import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/movie_model.dart';
import 'featured_hero.dart';
import 'movies_listview.dart';

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

  /// Series: Trending is the carousel, then Airing Today first among rails.
  static const tvFeeds = [trendingTv, airingToday, popularTv, egyptianTv];

  bool get isTv => tvFeeds.contains(this);
}

/// Home's sections for one mode (Movies or Series): the featured title
/// (Home v2), then three poster rails, as a sliver. The rails sit in a lazy
/// [SliverList], so only the ones near the viewport are built.
class Home_page_listview extends StatelessWidget {
  const Home_page_listview({
    super.key,
    required this.movie,
    required this.futureOf,
    required this.onRetry,
    required this.signedIn,
    this.onFocusChanged,
  });

  /// Movies when true, series otherwise.
  final bool movie;

  /// The (cached) future of a feed.
  final Future<Model> Function(HomeFeed feed) futureOf;

  /// Reloads one feed.
  final ValueChanged<HomeFeed> onRetry;

  /// Signed in (the featured title's Watchlist button).
  final bool signedIn;

  /// The featured item (Home's ambient-light source).
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
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: FeaturedHero(
            future: futureOf(hero),
            headlineText: title(hero),
            istvshow: hero.isTv,
            heroSource: hero.name,
            signedIn: signedIn,
            onRetry: () => onRetry(hero),
            onFocusChanged: onFocusChanged,
          ),
        ),
        SliverList.list(
          children: [
            for (final feed in feeds.skip(1))
              MoviesListView(
                future: futureOf(feed),
                headlineText: title(feed),
                istvshow: feed.isTv,
                heroSource: feed.name,
                onRetry: () => onRetry(feed),
                style: feed == HomeFeed.trending
                    ? RailStyle.ranked
                    : RailStyle.compact,
                badge: feed == HomeFeed.airingToday ? s.newEpisode : null,
              ),
          ],
        ),
      ],
    );
  }
}
