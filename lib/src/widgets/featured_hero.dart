import 'dart:math' as math;

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/l10n.dart';
import '../components/cached_image.dart';
import '../components/poster_card.dart' show heroTagFor, railHeroShuttle;
import '../components/state_views.dart';
import '../design/motion.dart';
import '../design/tokens.dart';
import '../models/movie_model.dart';
import '../navigation/routes.dart';
import '../pages/UI/detail_preview.dart';
import '../repository/Getvideos.dart';
import '../utils/poster_size.dart';
import '../utils/utils.dart' show getGenres, tmdbImage;
import 'addtowatchlist.dart';
import 'movies_listview.dart' show isTvResult;

/// Home v2's featured title: the first [maxCount] items of a feed, one at a
/// time, edge to edge at the top of Home (under the status bar). The image
/// fades into the page; on it sit the feed's name (opens See All), the
/// title, its rating, year and genres, Watch Trailers and a Watchlist
/// toggle, and a short position bar. Swiping changes the title and reports
/// it through [onFocusChanged] (Home's ambient light).
class FeaturedHero extends StatefulWidget {
  const FeaturedHero({
    super.key,
    required this.future,
    required this.headlineText,
    required this.istvshow,
    required this.signedIn,
    this.onRetry,
    this.onFocusChanged,
    this.heroSource,
  });

  final Future<Model> future;
  final String headlineText;
  final bool istvshow;

  /// Signed out, Watchlist opens the sign-in sheet instead.
  final bool signedIn;

  /// Reloads [future]. When null a failed load leaves only the space.
  final VoidCallback? onRetry;

  /// Called with the shown item (on load and on every page change).
  final ValueChanged<Result>? onFocusChanged;

  /// Section key for [heroTagFor]; defaults to [headlineText].
  final String? heroSource;

  /// Titles in the hero.
  static const int maxCount = 5;

  /// Page margin of the hero's text.
  static const double margin = 20;

  /// About two thirds of the screen, never taller than a 2:3 image of the
  /// screen's width; taller at large text so the text keeps its room.
  static double heightOf(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scale = math.max(1.0, MediaQuery.textScalerOf(context).scale(1));
    final base = math.min(size.height * 0.68, size.width * 1.5);
    return math.max(base, 420) + (scale - 1) * 160;
  }

  @override
  State<FeaturedHero> createState() => _FeaturedHeroState();
}

class _FeaturedHeroState extends State<FeaturedHero> {
  final PageController _pages = PageController();
  int _index = 0;
  Future<Model>? _reported;
  Model? _lastGood;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _reportInitial(List<Result> items) {
    if (identical(_reported, widget.future)) return;
    _reported = widget.future;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onFocusChanged?.call(items[_index.clamp(0, items.length - 1)]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = FeaturedHero.heightOf(context);
    final top = MediaQuery.paddingOf(context).top;
    return FutureBuilder<Model>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) _lastGood = snapshot.data;
        final data = snapshot.data ?? _lastGood;
        if (data == null) {
          if (!snapshot.hasError) {
            return SizedBox(
              height: height,
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
              ),
            );
          }
          final retry = widget.onRetry;
          return Padding(
            // Clears the floating type switch.
            padding: EdgeInsetsDirectional.only(top: top + 72),
            child: retry == null
                ? const SizedBox.shrink()
                : ErrorState(
                    compact: true,
                    message: S.of(context).somethingwentwrong,
                    onRetry: retry,
                  ),
          );
        }
        final items = [
          for (final r in data.results)
            if (r.posterPath != null && r.id != null) r,
        ].take(FeaturedHero.maxCount).toList();
        if (items.isEmpty) return SizedBox(height: top + 72);
        _reportInitial(items);
        final index = _index.clamp(0, items.length - 1);
        final item = items[index];
        final source = widget.heroSource ?? widget.headlineText;
        final isTv = isTvResult(item, railIsTv: widget.istvshow);
        final motion = MNMotion.of(context);

        return SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pages,
                // Builds (and so loads) the next title before the swipe.
                allowImplicitScrolling: true,
                itemCount: items.length,
                onPageChanged: (i) {
                  HapticFeedback.selectionClick();
                  setState(() => _index = i);
                  widget.onFocusChanged?.call(items[i]);
                },
                itemBuilder: (context, i) => _HeroImage(
                  item: items[i],
                  source: source,
                  railIsTv: widget.istvshow,
                ),
              ),
              PositionedDirectional(
                start: FeaturedHero.margin,
                end: FeaturedHero.margin,
                bottom: MNSpace.xl,
                child: AnimatedSwitcher(
                  duration: motion.fade(MNDuration.short),
                  switchInCurve: MNCurves.standard,
                  switchOutCurve: MNCurves.standard,
                  layoutBuilder: (current, previous) => Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [...previous, if (current != null) current],
                  ),
                  child: _HeroInfo(
                    key: ValueKey(item.id),
                    item: item,
                    isTv: isTv,
                    headlineText: widget.headlineText,
                    signedIn: widget.signedIn,
                    onSeeAll: () => openSeeAll(
                      context,
                      title: widget.headlineText,
                      load: () => widget.future,
                      isTv: widget.istvshow,
                    ),
                    count: items.length,
                    index: index,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// One page: the poster, edge to edge, fading out from about a third of the
/// way down so the page (and its ambient light) shows through. Tapping it
/// opens the title.
class _HeroImage extends StatelessWidget {
  const _HeroImage({
    required this.item,
    required this.source,
    required this.railIsTv,
  });

  final Result item;
  final String source;
  final bool railIsTv;

  /// Where the fade starts and where the image is gone (fully page colour).
  static const List<double> fadeStops = [0, 0.35, 0.95];

  /// The largest poster TMDB serves below "original"; decoding more than
  /// this only costs texture upload time while swiping.
  static const double maxDecodePixels = 780;

  @override
  Widget build(BuildContext context) {
    final isTv = isTvResult(item, railIsTv: railIsTv);
    final title = item.title ?? item.name ?? '';
    final genres = getGenres(item.genreIds ?? const []);
    final heroTag = heroTagFor(source: source, isTv: isTv, id: item.id!);
    final surface = Theme.of(context).colorScheme.surface;
    void open() => openTitle(
          context,
          id: item.id!,
          isTv: isTv,
          heroTag: heroTag,
          preview: DetailPreview.fromResult(item, isTv: isTv),
        );

    return Semantics(
      container: true,
      button: true,
      label: genres.isEmpty ? title : '$title, $genres',
      excludeSemantics: true,
      onTap: open,
      child: GestureDetector(
        onTap: open,
        // The fade is the page colour painted over the image, not a mask:
        // a mask is an extra off-screen pass on every frame (measured on the
        // A50 while swiping). Home's ambient light starts where it ends.
        child: RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              LayoutBuilder(
                builder: (context, box) {
                  // Wide screens show the landscape backdrop when there is one.
                  final wide = box.maxWidth >= PosterSize.tabletBreakpoint &&
                      item.backdropPath != null;
                  final path = wide ? item.backdropPath! : item.posterPath!;
                  final dpr = MediaQuery.devicePixelRatioOf(context);
                  return Hero(
                    tag: heroTag,
                    flightShuttleBuilder: railHeroShuttle,
                    child: CachedImageCustom(
                      tmdbImage(path, box.maxWidth * dpr),
                      width: box.maxWidth,
                      height: box.maxHeight,
                      decodeWidth:
                          math.min(box.maxWidth, maxDecodePixels / dpr),
                    ),
                  );
                },
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      surface.withValues(alpha: 0),
                      surface.withValues(alpha: 0),
                      surface
                    ],
                    stops: fadeStops,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The text and actions on the hero.
class _HeroInfo extends StatelessWidget {
  const _HeroInfo({
    super.key,
    required this.item,
    required this.isTv,
    required this.headlineText,
    required this.signedIn,
    required this.onSeeAll,
    required this.count,
    required this.index,
  });

  final Result item;
  final bool isTv;
  final String headlineText;
  final bool signedIn;
  final VoidCallback onSeeAll;
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;
    final s = S.of(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final title = item.title ?? item.name ?? '';
    final date = item.releaseDate ?? item.firstAirDate ?? '';
    final year = date.length >= 4 ? date.substring(0, 4) : '';
    final genres = getGenres(item.genreIds ?? const []);
    final score = item.voteAverage ?? 0;
    final rest = [if (year.isNotEmpty) year, if (genres.isNotEmpty) genres];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The feed's name, which opens its See All list.
        Semantics(
          button: true,
          child: InkWell(
            onTap: onSeeAll,
            borderRadius: MNRadius.smAll,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: MNSize.minTap),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      headlineText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelLarge!.copyWith(color: cs.primary),
                    ),
                  ),
                  Icon(
                    rtl
                        ? IconsaxOutline.arrow_left_3
                        : IconsaxOutline.arrow_right_3,
                    size: 16,
                    color: cs.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
        ExcludeSemantics(
          // The image above is the button that reads the title.
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.displaySmall!.copyWith(color: cs.onSurface),
          ),
        ),
        const SizedBox(height: MNSpace.sm),
        Row(
          children: [
            if (score > 0) ...[
              Icon(
                IconsaxBold.star_1,
                size: 16,
                color: MNColors.of(context).rating,
              ),
              const SizedBox(width: MNSpace.xs),
              Semantics(
                label: s.ratingOutOf10(score.toStringAsFixed(1)),
                excludeSemantics: true,
                child: Text(score.toStringAsFixed(1), style: text.labelLarge),
              ),
              if (rest.isNotEmpty) const SizedBox(width: MNSpace.sm),
            ],
            if (rest.isNotEmpty)
              Flexible(
                child: Text(
                  '${score > 0 ? '·  ' : ''}${rest.join('  ·  ')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
          ],
        ),
        const SizedBox(height: MNSpace.lg),
        Wrap(
          spacing: MNSpace.md,
          runSpacing: MNSpace.sm,
          children: [
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => VideosPage(movieid: item.id, isTvShow: isTv),
                ),
              ),
              icon: const Icon(IconsaxBold.play_circle),
              label: Text(s.watchTrailers),
            ),
            if (signedIn)
              Watchlistwidget(
                key: ValueKey('watchlist-${isTv ? 'tv' : 'movie'}-${item.id}'),
                movieid: item.id!,
                istvshow: isTv,
                builder: (context, inList, toggle) => FilledButton.tonalIcon(
                  onPressed: toggle,
                  icon: Icon(
                    inList ? IconsaxBold.bookmark : IconsaxOutline.bookmark,
                  ),
                  label: Text(inList ? s.inWatchlist : s.addtowatchlist),
                ),
              )
            else
              FilledButton.tonalIcon(
                onPressed: () => presentSignIn(context),
                icon: const Icon(IconsaxOutline.bookmark),
                label: Text(s.addtowatchlist),
              ),
          ],
        ),
        const SizedBox(height: MNSpace.lg),
        _PositionBar(count: count, index: index),
      ],
    );
  }
}

/// Which of the hero's titles is shown: one long segment among short ones.
class _PositionBar extends StatelessWidget {
  const _PositionBar({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (count < 2) return const SizedBox.shrink();
    final color = Theme.of(context).colorScheme.onSurface;
    final motion = MNMotion.of(context);
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: motion(MNDuration.short),
              curve: MNCurves.standard,
              margin: const EdgeInsetsDirectional.only(end: 6),
              width: i == index ? 28 : 12,
              height: 4,
              decoration: BoxDecoration(
                color: i == index ? color : color.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
