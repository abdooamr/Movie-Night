import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key, @visibleForTesting this.fetch});

  /// Test hook replacing the network feeds.
  final Future<Model> Function(HomeFeed feed, String lang)? fetch;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Fetched lazily per feed (TV feeds only once the TV tab is shown), then
  /// cached until a retry, a pull-to-refresh or a language change replaces
  /// them.
  final Map<HomeFeed, Future<Model>> _futures = {};

  /// Language the cached [_futures] were fetched in.
  late String _feedLang;
  bool _hasLang = false;

  bool _isMovie = true;

  /// The spill-glow source (the centred carousel poster). A notifier, so a
  /// carousel swipe repaints only the glow instead of rebuilding Home.
  final ValueNotifier<ImageProvider?> _glow = ValueNotifier(null);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listens: the saved language arrives after the first frame on launch,
    // and the user can change it in Settings. Either way, refetch in it.
    final lang = Provider.of<DropdownProvider>(context).selectedValue;
    if (_hasLang && lang != _feedLang) {
      _futures.clear();
      _glow.value = null;
    }
    _feedLang = lang;
    _hasLang = true;
  }

  Future<Model> _fetch(HomeFeed feed) {
    final lang = _feedLang;
    final override = widget.fetch;
    if (override != null) return override(feed, lang);
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

  // A block body: an arrow would hand setState the Future.
  void _retry(HomeFeed feed) => setState(() {
        _futures[feed] = _fetch(feed);
      });

  Future<void> _reload() async {
    final feeds = _isMovie ? HomeFeed.movieFeeds : HomeFeed.tvFeeds;
    setState(() {
      for (final f in feeds) {
        // Bypasses the TMDB caches, so a pull really fetches new data.
        _futures[f] = refreshing(() => _fetch(f));
      }
    });
    await Future.wait(
      feeds.map((f) => _futures[f]!.then((_) {}, onError: (_) {})),
    );
  }

  void _setMode(bool movie) {
    setState(() {
      _isMovie = movie;
    });
    _glow.value = null;
    final controller = PrimaryScrollController.maybeOf(context);
    if (controller != null && controller.hasClients) {
      // Instant: a scroll animation plus a rebuild in the same frames is
      // what stutters, and the new mode starts at its top anyway.
      controller.jumpTo(0);
    }
  }

  void _onFocus(Result item) {
    final path = item.posterPath;
    final next = path == null
        ? null
        : CachedNetworkImageProvider(
            // The glow is baked at 64 px, so the smallest size will do.
            tmdbImage(path, SpillGlow.bakeWidth.toDouble()),
          );
    if (next == _glow.value) return;
    _glow.value = next;
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: _reload,
        child: CustomScrollView(
          primary: true,
          // Default pre-build distance; in low power only what is visible is
          // built. A full screen ahead was measured slower on the A50
          // (raster p90 9.6 -> 11.4 ms, docs/perf/home-scroll.md).
          cacheExtent: MNMotion.of(context).lowPower ? 0 : null,
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.textScalerOf(context)
                  .scale(MNSize.minTap)
                  .clamp(kToolbarHeight, double.infinity),
              title: _TypeSwitch(
                tvLabel: s.tvswitch,
                movieLabel: s.movieswitch,
                isMovie: _isMovie,
                onChanged: _setMode,
              ),
            ),
            // Swapped instantly: a cross-fade would hold two full trees.
            Home_page_listview(
              key: ValueKey(_isMovie),
              movie: _isMovie,
              futureOf: _futureOf,
              onRetry: _retry,
              onFocusChanged: _onFocus,
              // The notifier child is built once per Home rebuild, not per
              // glow change.
              wrapHero: (hero) => ValueListenableBuilder<ImageProvider?>(
                valueListenable: _glow,
                child: hero,
                builder: (context, source, child) =>
                    SpillGlow(source: source, child: child!),
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

/// TikTok-style "TV Shows | Movies" switch: two text tabs, the selected one
/// in full colour, the other dimmed.
class _TypeSwitch extends StatelessWidget {
  const _TypeSwitch({
    required this.tvLabel,
    required this.movieLabel,
    required this.isMovie,
    required this.onChanged,
  });

  final String tvLabel;
  final String movieLabel;
  final bool isMovie;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.titleLarge!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _tab(context, tvLabel, !isMovie, () => onChanged(false), style, cs),
        ExcludeSemantics(
          child: Padding(
            padding:
                const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.sm),
            child: Text('|', style: style.copyWith(color: cs.outline)),
          ),
        ),
        _tab(context, movieLabel, isMovie, () => onChanged(true), style, cs),
      ],
    );
  }

  Widget _tab(BuildContext context, String label, bool selected,
      VoidCallback onTap, TextStyle style, ColorScheme cs) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: selected ? null : onTap,
        borderRadius: MNRadius.smAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: MNSize.minTap,
            minHeight: MNSize.minTap,
          ),
          child: Padding(
            padding:
                const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.sm),
            child: Center(
              widthFactor: 1,
              child: AnimatedDefaultTextStyle(
                duration: MNMotion.of(context).fade(MNDuration.short),
                curve: MNCurves.standard,
                style: style.copyWith(
                  fontWeight: FontWeight.w700,
                  color: selected ? cs.onSurface : cs.onSurfaceVariant,
                ),
                child: Text(label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
