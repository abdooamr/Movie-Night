import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/segmented_toggle.dart';
import 'package:Movie_Night/src/components/spill_glow.dart';
import 'package:Movie_Night/src/design/motion.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:Movie_Night/src/widgets/Home_page_listview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Brand name; not translated.
const String _appTitle = 'Movie Night';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final DropdownProvider _lang =
      Provider.of<DropdownProvider>(context, listen: false);

  /// Fetched lazily per feed (TV feeds only once the TV tab is shown), then
  /// cached until a retry or pull-to-refresh replaces them.
  final Map<HomeFeed, Future<Model>> _futures = {};

  bool _isMovie = true;
  ImageProvider? _glow;

  Future<Model> _fetch(HomeFeed feed) {
    final lang = _lang.selectedValue;
    return switch (feed) {
      HomeFeed.upcoming => getUpcomingMovies(lang),
      HomeFeed.trending => getTrending(false, lang),
      HomeFeed.popular => getPopular(false, lang),
      HomeFeed.egyptian => getEgyptionmovies(false, lang),
      HomeFeed.airingToday => getAiringToday(lang),
      HomeFeed.trendingTv => getTrending(true, lang),
      HomeFeed.popularTv => getPopular(true, lang),
      HomeFeed.egyptianTv => getEgyptionmovies(true, lang),
    };
  }

  Future<Model> _futureOf(HomeFeed feed) =>
      _futures.putIfAbsent(feed, () => _fetch(feed));

  void _retry(HomeFeed feed) => setState(() => _futures[feed] = _fetch(feed));

  Future<void> _reload() async {
    final feeds = _isMovie ? HomeFeed.movieFeeds : HomeFeed.tvFeeds;
    setState(() {
      for (final f in feeds) {
        _futures[f] = _fetch(f);
      }
    });
    await Future.wait(
      feeds.map((f) => _futures[f]!.then((_) {}, onError: (_) {})),
    );
  }

  void _setMode(bool movie) {
    setState(() {
      _isMovie = movie;
      _glow = null;
    });
    final controller = PrimaryScrollController.maybeOf(context);
    if (controller != null && controller.hasClients) {
      controller.animateTo(
        0,
        duration: MNMotion.of(context)(MNDuration.medium),
        curve: MNCurves.standard,
      );
    }
  }

  void _onFocus(Result item) {
    final path = item.posterPath;
    final next =
        path == null ? null : CachedNetworkImageProvider('$imageUrl$path');
    if (next == _glow) return;
    setState(() => _glow = next);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final motion = MNMotion.of(context);
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: _reload,
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverAppBar.large(title: const Text(_appTitle)),
            SliverPersistentHeader(
              pinned: true,
              delegate: _ToggleHeader(
                height: MediaQuery.textScalerOf(context).scale(MNSize.minTap) +
                    2 * MNSpace.sm,
                color: Theme.of(context).colorScheme.surface,
                child: SegmentedToggle<bool>(
                  segments: [
                    (true, s.movieswitch),
                    (false, s.tvswitch),
                  ],
                  selected: _isMovie,
                  onChanged: _setMode,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SpillGlow(
                source: _glow,
                child: AnimatedSwitcher(
                  duration: motion.fade(MNDuration.short),
                  child: Home_page_listview(
                    key: ValueKey(_isMovie),
                    movie: _isMovie,
                    futureOf: _futureOf,
                    onRetry: _retry,
                    onFocusChanged: _onFocus,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                // Clears the floating iOS tab bar (and the safe area).
                height: MediaQuery.paddingOf(context).bottom + MNSpace.xl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pinned Movies / TV switch under the large title.
class _ToggleHeader extends SliverPersistentHeaderDelegate {
  _ToggleHeader({
    required this.height,
    required this.color,
    required this.child,
  });

  final double height;
  final Color color;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: MNSpace.lg,
          vertical: MNSpace.sm,
        ),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_ToggleHeader old) =>
      old.height != height || old.color != color || old.child != child;
}
