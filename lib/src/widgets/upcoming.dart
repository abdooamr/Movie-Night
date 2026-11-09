import 'package:carousel_slider/carousel_slider.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/l10n.dart';
import '../components/cached_image.dart';
import '../components/poster_card.dart' show heroTagFor, railHeroShuttle;
import '../components/pressable.dart';
import '../components/section_header.dart';
import '../components/state_views.dart';
import '../design/motion.dart';
import '../design/tokens.dart';
import '../models/movie_model.dart';
import '../navigation/routes.dart';
import '../pages/UI/detail_preview.dart';
import '../utils/poster_size.dart';
import '../utils/utils.dart' show getGenres, tmdbImage;
import 'carousel_slider.dart';
import 'movies_listview.dart' show isTvResult;
import 'shimmerWidgets/upcomingShimmerWidget.dart';

/// The Home hero carousel: [SectionHeader] with "See All", a carousel of
/// posters with a gradient-scrim caption, and a dot indicator.
///
/// [onFocusChanged] reports the centred item (on load and on every page
/// change), which Home uses as the spill-glow source.
class UpcomingMovies extends StatefulWidget {
  const UpcomingMovies({
    required this.future,
    required this.headlineText,
    required this.istvshow,
    this.onRetry,
    this.onFocusChanged,
    this.heroSource,
    Key? key,
  }) : super(key: key);

  final Future<Model> future;
  final String headlineText;
  final bool istvshow;

  /// Reloads [future]. When null a failed load hides the section.
  final VoidCallback? onRetry;

  /// Called with the centred item.
  final ValueChanged<Result>? onFocusChanged;

  /// Section key for [heroTagFor]; defaults to [headlineText].
  final String? heroSource;

  /// Items in the carousel.
  static const int maxCount = 20;

  /// The hero poster is a little larger than a rail poster.
  static const double _heroScale = 1.2;

  /// Width of the centred carousel poster.
  static double posterWidthOf(BuildContext context) =>
      PosterSize.of(context).width * _heroScale;

  /// Height of the centred carousel poster (2:3).
  static double posterHeightOf(BuildContext context) =>
      posterWidthOf(context) / PosterSize.posterAspect;

  @override
  State<UpcomingMovies> createState() => _UpcomingMoviesState();
}

class _UpcomingMoviesState extends State<UpcomingMovies> {
  final ValueNotifier<int> _index = ValueNotifier(0);

  /// The future whose centred item has been reported to [onFocusChanged].
  Future<Model>? _reported;

  /// The last successful result, kept on screen while a refresh is pending
  /// or after it fails.
  Model? _lastGood;

  @override
  void dispose() {
    _index.dispose();
    super.dispose();
  }

  void _reportInitial(List<Result> items) {
    if (identical(_reported, widget.future)) return;
    _reported = widget.future;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.onFocusChanged == null) return;
      final i = _index.value.clamp(0, items.length - 1);
      widget.onFocusChanged!(items[i]);
    });
  }

  void _open(Result item, String source) {
    final isTv = isTvResult(item, railIsTv: widget.istvshow);
    openTitle(
      context,
      id: item.id!,
      isTv: isTv,
      heroTag: heroTagFor(source: source, isTv: isTv, id: item.id!),
      preview: DetailPreview.fromResult(item, isTv: isTv),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Model>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) _lastGood = snapshot.data;
        final data = snapshot.data ?? _lastGood;
        if (data == null) {
          if (!snapshot.hasError) {
            return const _SectionPadding(child: upcomingShimmerWidget());
          }
          final retry = widget.onRetry;
          if (retry == null) return const SizedBox.shrink();
          return _SectionPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeader(title: widget.headlineText),
                ErrorState(
                  compact: true,
                  message: S.of(context).somethingwentwrong,
                  onRetry: retry,
                ),
              ],
            ),
          );
        }
        final results = data.results;
        if (results.isEmpty) return const SizedBox.shrink();
        final items = results.take(UpcomingMovies.maxCount).toList();
        _reportInitial(items);

        final source = widget.heroSource ?? widget.headlineText;
        final width = UpcomingMovies.posterWidthOf(context);
        final height = UpcomingMovies.posterHeightOf(context);
        return _SectionPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(
                title: widget.headlineText,
                onSeeAll: () => openSeeAll(
                  context,
                  title: widget.headlineText,
                  load: () => widget.future,
                  isTv: widget.istvshow,
                ),
              ),
              const SizedBox(height: MNSpace.sm),
              MyCarouselSlider(
                height: height,
                viewportFraction:
                    ((width + MNSpace.lg) / MediaQuery.sizeOf(context).width)
                        .clamp(0.2, 0.6),
                itemCount: items.length,
                onPageChanged: (index, reason) {
                  if (reason == CarouselPageChangedReason.manual) {
                    HapticFeedback.selectionClick();
                  }
                  _index.value = index;
                  widget.onFocusChanged?.call(items[index]);
                },
                itemBuilder: (context, index, realIndex) {
                  final item = items[index];
                  final isTv = isTvResult(item, railIsTv: widget.istvshow);
                  return Center(
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: _HeroPoster(
                        item: item,
                        heroTag: heroTagFor(
                          source: source,
                          isTv: isTv,
                          id: item.id!,
                        ),
                        onTap: () => _open(item, source),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: MNSpace.md),
              ValueListenableBuilder<int>(
                valueListenable: _index,
                builder: (context, index, _) => _Dots(
                  count: items.length,
                  index: index.clamp(0, items.length - 1),
                ),
              ),
              // A failed refresh keeps the carousel and offers a retry.
              if (snapshot.hasError && widget.onRetry != null)
                ErrorState(
                  compact: true,
                  message: S.of(context).somethingwentwrong,
                  onRetry: widget.onRetry!,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionPadding extends StatelessWidget {
  const _SectionPadding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: MNSpace.md),
        child: child,
      );
}

/// A carousel poster: image with a [MNColors.scrim] caption (title, genres)
/// instead of a blur. One button "title, genres" for assistive tech.
class _HeroPoster extends StatelessWidget {
  const _HeroPoster({
    required this.item,
    required this.heroTag,
    required this.onTap,
  });

  final Result item;
  final String heroTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final mn = MNColors.of(context);
    final title = item.title ?? item.name ?? '';
    final genres = getGenres(item.genreIds ?? const []);
    final label = genres.isEmpty ? title : '$title, $genres';

    return Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: PressableScale(
        onTap: onTap,
        borderRadius: MNRadius.mdAll,
        child: ClipRRect(
          borderRadius: MNRadius.mdAll,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // The Hero wraps a fixed-size image, so a flight never changes
              // its URL.
              Hero(
                tag: heroTag,
                flightShuttleBuilder: railHeroShuttle,
                child: LayoutBuilder(
                  builder: (context, constraints) => item.posterPath == null
                      ? ColoredBox(
                          color: cs.surfaceContainer,
                          child: Center(
                            child: Icon(
                              IconsaxOutline.video,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        )
                      : CachedImageCustom(
                          tmdbImage(
                            item.posterPath!,
                            UpcomingMovies.posterWidthOf(context) *
                                MediaQuery.devicePixelRatioOf(context),
                          ),
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          decodeWidth: UpcomingMovies.posterWidthOf(context),
                          borderRadius: MNRadius.mdAll,
                        ),
                ),
              ),
              PositionedDirectional(
                start: 0,
                end: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: mn.scrim),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      MNSpace.md,
                      MNSpace.xl,
                      MNSpace.md,
                      MNSpace.md,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium!
                              .copyWith(color: mn.onScrim),
                        ),
                        if (genres.isNotEmpty)
                          Text(
                            genres,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium!
                                .copyWith(color: mn.onScrim),
                          ),
                      ],
                    ),
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

/// Page dots. Only opacity and scale animate.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  static const double _restScale = 0.6;
  static const double _restOpacity = 0.35;

  @override
  Widget build(BuildContext context) {
    final motion = MNMotion.of(context);
    final color = Theme.of(context).colorScheme.onSurface;
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: MNSpace.xxs,
              ),
              child: AnimatedScale(
                scale: i == index ? 1 : _restScale,
                duration: motion(MNDuration.short),
                curve: MNCurves.standard,
                child: AnimatedOpacity(
                  opacity: i == index ? 1 : _restOpacity,
                  duration: motion.fade(MNDuration.short),
                  curve: MNCurves.standard,
                  child: SizedBox.square(
                    dimension: MNSpace.sm,
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
