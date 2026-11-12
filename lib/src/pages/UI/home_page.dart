import 'dart:async';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/glass.dart';
import 'package:Movie_Night/src/components/spill_glow.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/design/motion.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:Movie_Night/src/widgets/Home_page_listview.dart';
import 'package:Movie_Night/src/widgets/featured_hero.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Home v2: the featured title edge to edge under the status bar, its colours
/// spilling down the page as ambient light, rails below, and only the
/// Series | Movies switch (and the tab bar) floating above on glass.
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    @visibleForTesting this.fetch,
    @visibleForTesting this.signedIn,
  });

  /// Test hook replacing the network feeds.
  final Future<Model> Function(HomeFeed feed, String lang)? fetch;

  /// Test hook replacing the signed-in state (and its updates).
  final bool? signedIn;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Fetched lazily per feed (series feeds only once Series is shown), then
  /// cached until a retry, a pull-to-refresh or a language change replaces
  /// them.
  final Map<HomeFeed, Future<Model>> _futures = {};

  /// Language the cached [_futures] were fetched in.
  late String _feedLang;
  bool _hasLang = false;

  bool _isMovie = true;

  late bool _signedIn;
  StreamSubscription<Object?>? _authSub;

  /// The ambient-light source (the featured poster). A notifier, so a swipe
  /// repaints only the light instead of rebuilding Home.
  final ValueNotifier<ImageProvider?> _glow = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    final forced = widget.signedIn;
    if (forced != null) {
      _signedIn = forced;
    } else {
      _signedIn = AuthRepository.instance.isSignedIn;
      _authSub = AuthRepository.instance.authStateChanges.listen((_) {
        final now = AuthRepository.instance.isSignedIn;
        if (mounted && now != _signedIn) setState(() => _signedIn = now);
      });
    }
  }

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
    if (movie == _isMovie) return;
    HapticFeedback.selectionClick();
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
            // The light is baked at 64 px, so the smallest size will do.
            tmdbImage(path, SpillGlow.bakeWidth.toDouble()),
          );
    if (next == _glow.value) return;
    _glow.value = next;
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final controller = PrimaryScrollController.maybeOf(context);
    final heroHeight = FeaturedHero.heightOf(context);
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      body: Stack(
        children: [
          if (controller != null && !MediaQuery.highContrastOf(context))
            _AmbientLight(
              controller: controller,
              glow: _glow,
              // Starts where the featured image has faded into the page
              // colour (FeaturedHero fadeStops), so there is no seam.
              top: heroHeight * 0.9,
            ),
          RefreshIndicator.adaptive(
            onRefresh: _reload,
            edgeOffset: top + _TopLayer.barHeight,
            child: CustomScrollView(
              primary: true,
              // Default pre-build distance; in low power only what is visible
              // is built. A full screen ahead was measured slower on the A50
              // (raster p90 9.6 -> 11.4 ms, docs/perf/home-scroll.md).
              cacheExtent: MNMotion.of(context).lowPower ? 0 : null,
              slivers: [
                // Swapped instantly: a cross-fade would hold two full trees.
                Home_page_listview(
                  key: ValueKey(_isMovie),
                  movie: _isMovie,
                  futureOf: _futureOf,
                  onRetry: _retry,
                  signedIn: _signedIn,
                  onFocusChanged: _onFocus,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    // Clears the floating tab bar (and the safe area).
                    height: MediaQuery.paddingOf(context).bottom + MNSpace.xl,
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: _TopLayer(
              controller: controller,
              heroHeight: heroHeight,
              child: _TypeSwitch(
                tvLabel: s.tvswitch,
                movieLabel: s.movieswitch,
                isMovie: _isMovie,
                onChanged: _setMode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The featured poster's colours, baked small and blurred, lying behind the
/// page below the featured title and moving with the scroll. Its ends fade
/// into the page by painting the page colour over them (the page is the
/// only thing behind it), which costs nothing per frame, unlike a mask.
class _AmbientLight extends StatelessWidget {
  const _AmbientLight({
    required this.controller,
    required this.glow,
    required this.top,
  });

  final ScrollController controller;
  final ValueNotifier<ImageProvider?> glow;
  final double top;

  static const double height = 760;

  @override
  Widget build(BuildContext context) {
    final opacity = MNColors.of(context).glowOpacity;
    final motion = MNMotion.of(context);
    final surface = Theme.of(context).colorScheme.surface;
    final clear = surface.withValues(alpha: 0);
    final light = ExcludeSemantics(
      child: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ValueListenableBuilder<ImageProvider?>(
              valueListenable: glow,
              builder: (context, source, _) => AnimatedSwitcher(
                duration: motion(MNDuration.long),
                switchInCurve: MNCurves.standard,
                switchOutCurve: MNCurves.standard,
                layoutBuilder: (current, previous) => Stack(
                  fit: StackFit.expand,
                  children: [...previous, if (current != null) current],
                ),
                child: source == null
                    ? const SizedBox.expand(key: ValueKey('none'))
                    : BakedGlow(
                        key: ValueKey(source),
                        source: source,
                        opacity: opacity,
                      ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [surface, clear, clear, surface],
                  stops: const [0, 0.2, 0.5, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return Positioned.fill(
      child: IgnorePointer(
        child: ClipRect(
          child: AnimatedBuilder(
            animation: controller,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(height: height, child: light),
            ),
            builder: (context, child) {
              final offset =
                  controller.hasClients && controller.positions.length == 1
                      ? controller.offset
                      : 0.0;
              // A translation only: no layout, no repaint of the light.
              return Transform.translate(
                offset: Offset(0, top - offset),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// The floating layer at the top: a dark scrim over the featured image at
/// rest, which turns into a fade of the page colour once content scrolls
/// under it (a scroll edge effect instead of a solid bar), and the switch.
class _TopLayer extends StatelessWidget {
  const _TopLayer({
    required this.controller,
    required this.heroHeight,
    required this.child,
  });

  final ScrollController? controller;
  final double heroHeight;
  final Widget child;

  /// Height of the row holding the switch, under the status bar.
  static const double barHeight = 64;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final top = MediaQuery.paddingOf(context).top;
    final dark = theme.brightness == Brightness.dark;
    final c = controller;

    Widget layer(double t) => AnnotatedRegion<SystemUiOverlayStyle>(
          // Light icons over the image; the theme's own once scrolled.
          value: t < 0.5 || dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Stack(
            children: [
              Positioned.fill(
                bottom: -32,
                child: IgnorePointer(
                  // One gradient whose colours move from the dark scrim to
                  // the page-colour fade: no transparency layers per frame.
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.lerp(MNHome.topScrim[0],
                              surface.withValues(alpha: 0.92), t)!,
                          Color.lerp(MNHome.topScrim[1],
                              surface.withValues(alpha: 0), t)!,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top),
                child: SizedBox(
                  height: barHeight,
                  child: Center(child: child),
                ),
              ),
            ],
          ),
        );

    if (c == null) return layer(0);
    return AnimatedBuilder(
      animation: c,
      builder: (context, _) {
        final offset = c.hasClients && c.positions.length == 1 ? c.offset : 0.0;
        final t = ((offset - (heroHeight - 260)) / 140).clamp(0.0, 1.0);
        return layer(t);
      },
    );
  }
}

/// "Series | Movies" as a glass pill. Each half is a full-height button.
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

  /// Like the tab bar's labels, the switch caps its text scaling: it is
  /// chrome with fixed room, and its two words stay short.
  static const double maxTextScale = 1.4;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: maxTextScale,
      child: GlassSurface(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: MNSpace.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _segment(context, tvLabel, !isMovie, () => onChanged(false)),
              _segment(context, movieLabel, isMovie, () => onChanged(true)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _segment(
      BuildContext context, String label, bool selected, VoidCallback onTap) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final motion = MNMotion.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: selected ? null : onTap,
        customBorder: const StadiumBorder(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: MNSize.minTap,
            minHeight: MNSize.minTap,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: MNSpace.xs + 2),
            child: AnimatedContainer(
              duration: motion(MNDuration.short),
              curve: MNCurves.standard,
              padding: const EdgeInsets.symmetric(horizontal: MNSpace.lg),
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: selected
                    ? cs.onSurface.withValues(alpha: 0.15)
                    : cs.onSurface.withValues(alpha: 0),
              ),
              child: Text(
                label,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: selected ? cs.onSurface : cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
