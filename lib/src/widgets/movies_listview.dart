import 'dart:math' as math;

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../components/cached_image.dart';
import '../components/poster_card.dart';
import '../components/pressable.dart';
import '../components/section_header.dart';
import '../components/state_views.dart';
import '../design/tokens.dart';
import '../models/movie_model.dart';
import '../navigation/routes.dart';
import '../pages/UI/detail_preview.dart';
import '../utils/poster_size.dart';
import '../utils/utils.dart' show getGenres, tmdbImage;
import 'shimmerWidgets/movieListViewShimmerWidget.dart';

/// Whether [item] opens as a TV title. Trending feeds carry a media type;
/// the others fall back to the rail's own kind.
bool isTvResult(Result item, {required bool railIsTv}) =>
    item.mediaType == MediaType.tv || (item.mediaType == null && railIsTv);

/// How a rail draws its items.
enum RailStyle {
  /// [PosterCard]s (See All, everywhere but Home).
  standard,

  /// Home v2: smaller posters with a rating chip, a one-line title and genres.
  compact,

  /// Home v2's Trending Movies: a large rank numeral behind each poster.
  ranked,
}

/// A titled poster rail: [SectionHeader] with "See All", then a horizontal
/// list of [PosterCard]s. At very large text ([PosterSize.stackRails]) the
/// first [stackedCount] items stack vertically as rows instead.
class MoviesListView extends StatefulWidget {
  const MoviesListView({
    required this.future,
    Key? key,
    required this.headlineText,
    required this.istvshow,
    this.onRetry,
    this.heroSource,
    this.style = RailStyle.standard,
    this.badge,
  }) : super(key: key);

  final String headlineText;

  /// How the items are drawn.
  final RailStyle style;

  /// A tag on every poster of a [RailStyle.compact] rail ("New episode").
  final String? badge;
  final Future<Model> future;
  final bool istvshow;

  /// Reloads [future]. When null a failed load hides the rail.
  final VoidCallback? onRetry;

  /// Rail key for [heroTagFor]; defaults to [headlineText].
  final String? heroSource;

  /// Items shown when the rail stacks vertically.
  static const int stackedCount = 6;

  /// Items shown in the horizontal rail.
  static const int maxCount = 20;

  /// Items shown in a ranked rail (a top ten).
  static const int rankedCount = 10;

  @override
  State<MoviesListView> createState() => _MoviesListViewState();
}

class _MoviesListViewState extends State<MoviesListView> {
  /// The last successful result, kept on screen while a refresh is pending
  /// or after it fails.
  Model? _lastGood;

  @override
  Widget build(BuildContext context) {
    final headlineText = widget.headlineText;
    final onRetry = widget.onRetry;
    return FutureBuilder<Model>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) _lastGood = snapshot.data;
        final data = snapshot.data ?? _lastGood;
        if (data == null) {
          if (!snapshot.hasError) {
            return const _RailPadding(child: movieListViewShimmerWidget());
          }
          if (onRetry == null) return const SizedBox.shrink();
          return _RailPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeader(title: headlineText),
                ErrorState(
                  compact: true,
                  message: S.of(context).somethingwentwrong,
                  onRetry: onRetry,
                ),
              ],
            ),
          );
        }
        final results = data.results;
        if (results.isEmpty) return const SizedBox.shrink();

        final size = PosterSize.of(context);
        final source = widget.heroSource ?? headlineText;
        final istvshow = widget.istvshow;
        void open(Result item) {
          final isTv = isTvResult(item, railIsTv: istvshow);
          openTitle(
            context,
            id: item.id!,
            isTv: isTv,
            heroTag: heroTagFor(source: source, isTv: isTv, id: item.id!),
            preview: DetailPreview.fromResult(item, isTv: isTv),
          );
        }

        return _RailPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(
                title: headlineText,
                onSeeAll: () => openSeeAll(
                  context,
                  title: headlineText,
                  load: () => widget.future,
                  isTv: istvshow,
                ),
              ),
              const SizedBox(height: MNSpace.sm),
              if (size.stackRails)
                _StackedRail(
                  items: results.take(MoviesListView.stackedCount).toList(),
                  size: size,
                  railIsTv: istvshow,
                  source: source,
                  onTap: open,
                )
              else if (widget.style == RailStyle.standard)
                _HorizontalRail(
                  items: results.take(MoviesListView.maxCount).toList(),
                  size: size,
                  railIsTv: istvshow,
                  source: source,
                  onTap: open,
                )
              else
                _HomeRail(
                  items: results
                      .take(widget.style == RailStyle.ranked
                          ? MoviesListView.rankedCount
                          : MoviesListView.maxCount)
                      .toList(),
                  size: size,
                  ranked: widget.style == RailStyle.ranked,
                  badge: widget.badge,
                  railIsTv: istvshow,
                  source: source,
                  onTap: open,
                ),
              // A failed refresh keeps the rail and offers a retry.
              if (snapshot.hasError && onRetry != null)
                ErrorState(
                  compact: true,
                  message: S.of(context).somethingwentwrong,
                  onRetry: onRetry,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RailPadding extends StatelessWidget {
  const _RailPadding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: MNSpace.md),
        child: child,
      );
}

class _HorizontalRail extends StatelessWidget {
  const _HorizontalRail({
    required this.items,
    required this.size,
    required this.railIsTv,
    required this.source,
    required this.onTap,
  });

  final List<Result> items;
  final PosterSize size;
  final bool railIsTv;
  final String source;
  final ValueChanged<Result> onTap;

  @override
  Widget build(BuildContext context) {
    final gutter = (size.itemExtent - size.width) / 2;
    return SizedBox(
      height: size.cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemExtent: size.itemExtent,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: MNSpace.lg - gutter,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isTv = isTvResult(item, railIsTv: railIsTv);
          return Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: gutter),
            child: PosterCard(
              posterPath: item.posterPath,
              title: item.title ?? item.name ?? '',
              subtitle: getGenres(item.genreIds ?? const []),
              width: size.width,
              heroTag: heroTagFor(source: source, isTv: isTv, id: item.id!),
              onTap: () => onTap(item),
            ),
          );
        },
      ),
    );
  }
}

/// Large-text layout: a fixed-height, non-scrolling vertical list of rows
/// (the outer page scrolls).
class _StackedRail extends StatelessWidget {
  const _StackedRail({
    required this.items,
    required this.size,
    required this.railIsTv,
    required this.source,
    required this.onTap,
  });

  final List<Result> items;
  final PosterSize size;
  final bool railIsTv;
  final String source;
  final ValueChanged<Result> onTap;

  @override
  Widget build(BuildContext context) {
    final thumbWidth = size.width / 2;
    final thumbHeight = thumbWidth / PosterSize.posterAspect;
    final extent = math.max(thumbHeight, size.captionHeight) + MNSpace.sm * 2;
    return SizedBox(
      height: extent * items.length,
      child: ListView.builder(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.zero,
        itemExtent: extent,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isTv = isTvResult(item, railIsTv: railIsTv);
          return _PosterRow(
            posterPath: item.posterPath,
            title: item.title ?? item.name ?? '',
            subtitle: getGenres(item.genreIds ?? const []),
            thumbWidth: thumbWidth,
            thumbHeight: thumbHeight,
            heroTag: heroTagFor(source: source, isTv: isTv, id: item.id!),
            onTap: () => onTap(item),
          );
        },
      ),
    );
  }
}

/// Row variant of [PosterCard]: thumbnail at the start, title and subtitle
/// beside it. One button "title, subtitle" for assistive tech.
class _PosterRow extends StatelessWidget {
  const _PosterRow({
    required this.posterPath,
    required this.title,
    required this.subtitle,
    required this.thumbWidth,
    required this.thumbHeight,
    required this.heroTag,
    required this.onTap,
  });

  final String? posterPath;
  final String title;
  final String subtitle;
  final double thumbWidth;
  final double thumbHeight;
  final String heroTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final label = subtitle.isEmpty ? title : '$title, $subtitle';
    final thumb = posterPath == null
        ? ClipRRect(
            borderRadius: MNRadius.smAll,
            child: ColoredBox(
              color: cs.surfaceContainer,
              child: Center(
                child: Icon(IconsaxOutline.video, color: cs.onSurfaceVariant),
              ),
            ),
          )
        : CachedImageCustom(
            tmdbImage(
              posterPath!,
              thumbWidth * MediaQuery.devicePixelRatioOf(context),
            ),
            width: thumbWidth,
            height: thumbHeight,
            borderRadius: MNRadius.smAll,
          );
    return Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: PressableScale(
        onTap: onTap,
        borderRadius: MNRadius.mdAll,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: MNSpace.lg,
            vertical: MNSpace.sm,
          ),
          child: Row(
            children: [
              SizedBox(
                width: thumbWidth,
                height: thumbHeight,
                child: Hero(
                  tag: heroTag,
                  flightShuttleBuilder: railHeroShuttle,
                  child: thumb,
                ),
              ),
              const SizedBox(width: MNSpace.md),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium!
                            .copyWith(color: cs.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Home v2 rails: compact cards, or ranked cards with a numeral behind each
/// poster. Both scale with [PosterSize] (and so with tablets).
class _HomeRail extends StatelessWidget {
  const _HomeRail({
    required this.items,
    required this.size,
    required this.ranked,
    required this.badge,
    required this.railIsTv,
    required this.source,
    required this.onTap,
  });

  final List<Result> items;
  final PosterSize size;
  final bool ranked;
  final String? badge;
  final bool railIsTv;
  final String source;
  final ValueChanged<Result> onTap;

  /// Poster width of a compact card, relative to a standard card.
  static const double compactScale = 0.78;

  /// Poster width of a ranked card, relative to a standard card.
  static const double rankedScale = 0.62;

  /// How far a ranked poster sits from the start of its card (the numeral).
  static const double rankInset = 52;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scaler = MediaQuery.textScalerOf(context);
    double line(TextStyle? s) =>
        scaler.scale(s?.fontSize ?? 14) * (s?.height ?? 1.2);
    final posterW = size.width * (ranked ? rankedScale : compactScale);
    final posterH = posterW / PosterSize.posterAspect;
    final caption = ranked
        ? line(text.labelLarge)
        : line(text.labelLarge) + MNSpace.xxs + line(text.labelSmall);
    final itemW = ranked ? posterW + rankInset : posterW;
    final height = posterH + MNSpace.sm + caption + 2;

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: ranked ? MNSpace.sm : MNSpace.lg,
        ),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            SizedBox(width: ranked ? MNSpace.xs : MNSpace.md),
        itemBuilder: (context, index) {
          final item = items[index];
          final isTv = isTvResult(item, railIsTv: railIsTv);
          final tag = heroTagFor(source: source, isTv: isTv, id: item.id!);
          return SizedBox(
            width: itemW,
            child: ranked
                ? _RankedCard(
                    rank: index + 1,
                    item: item,
                    posterW: posterW,
                    posterH: posterH,
                    heroTag: tag,
                    onTap: () => onTap(item),
                  )
                : _CompactCard(
                    item: item,
                    posterW: posterW,
                    posterH: posterH,
                    badge: badge,
                    heroTag: tag,
                    onTap: () => onTap(item),
                  ),
          );
        },
      ),
    );
  }
}

/// A poster image for the Home v2 cards: radius 16 and a faint edge.
class _HomePoster extends StatelessWidget {
  const _HomePoster({
    required this.path,
    required this.width,
    required this.height,
    required this.heroTag,
    this.radius = 16,
  });

  final String? path;
  final double width;
  final double height;
  final String heroTag;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final r = BorderRadius.circular(radius);
    final image = path == null
        ? ClipRRect(
            borderRadius: r,
            child: ColoredBox(
              color: cs.surfaceContainer,
              child: Center(
                child: Icon(IconsaxOutline.video, color: cs.onSurfaceVariant),
              ),
            ),
          )
        : CachedImageCustom(
            tmdbImage(path!, width * MediaQuery.devicePixelRatioOf(context)),
            width: width,
            height: height,
            borderRadius: r,
          );
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: r,
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
        ),
        child: Hero(
          tag: heroTag,
          flightShuttleBuilder: railHeroShuttle,
          child: image,
        ),
      ),
    );
  }
}

/// A small pill on a poster. Always dark, as it sits on artwork.
class _Chip extends StatelessWidget {
  const _Chip({required this.child, this.color = MNHome.chipOnArt});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: ShapeDecoration(color: color, shape: const StadiumBorder()),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: MNSpace.sm,
            vertical: MNSpace.xxs,
          ),
          child: child,
        ),
      );
}

class _CompactCard extends StatelessWidget {
  const _CompactCard({
    required this.item,
    required this.posterW,
    required this.posterH,
    required this.badge,
    required this.heroTag,
    required this.onTap,
  });

  final Result item;
  final double posterW;
  final double posterH;
  final String? badge;
  final String heroTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;
    final title = item.title ?? item.name ?? '';
    final genres = getGenres(item.genreIds ?? const []);
    final score = item.voteAverage ?? 0;
    final label = [
      title,
      if (genres.isNotEmpty) genres,
      if (score > 0) S.of(context).ratingOutOf10(score.toStringAsFixed(1)),
      if (badge != null) badge!,
    ].join(', ');
    return Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: PressableScale(
        onTap: onTap,
        borderRadius: MNRadius.mdAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _HomePoster(
                  path: item.posterPath,
                  width: posterW,
                  height: posterH,
                  heroTag: heroTag,
                ),
                if (score > 0)
                  PositionedDirectional(
                    top: MNSpace.sm,
                    start: MNSpace.sm,
                    child: _Chip(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconsaxBold.star_1,
                            size: 12,
                            color: MNColors.of(context).rating,
                          ),
                          const SizedBox(width: MNSpace.xxs),
                          Text(
                            score.toStringAsFixed(1),
                            style: text.labelSmall!.copyWith(
                              color: MNHome.onChipOnArt,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (badge != null)
                  PositionedDirectional(
                    bottom: MNSpace.sm,
                    start: MNSpace.sm,
                    end: MNSpace.sm,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _Chip(
                        color: cs.primary,
                        child: Text(
                          badge!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelSmall!.copyWith(color: cs.onPrimary),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: MNSpace.sm),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.labelLarge,
            ),
            const SizedBox(height: MNSpace.xxs),
            if (genres.isNotEmpty)
              Text(
                genres,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.labelSmall!.copyWith(color: cs.onSurfaceVariant),
              ),
          ],
        ),
      ),
    );
  }
}

class _RankedCard extends StatelessWidget {
  const _RankedCard({
    required this.rank,
    required this.item,
    required this.posterW,
    required this.posterH,
    required this.heroTag,
    required this.onTap,
  });

  final int rank;
  final Result item;
  final double posterW;
  final double posterH;
  final String heroTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;
    final title = item.title ?? item.name ?? '';
    return Semantics(
      container: true,
      button: true,
      label: S.of(context).rankedTitle(rank, title),
      excludeSemantics: true,
      onTap: onTap,
      child: PressableScale(
        onTap: onTap,
        borderRadius: MNRadius.mdAll,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            PositionedDirectional(
              start: 0,
              top: posterH * 0.28,
              child: Text(
                '$rank',
                textScaler: TextScaler.noScaling,
                style: text.displayLarge!
                    .apply(
                      fontSizeFactor: posterW *
                          MNHome.rankScale /
                          text.displayLarge!.fontSize!,
                    )
                    .copyWith(
                      height: 1,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface.withValues(alpha: 0.14),
                    ),
              ),
            ),
            PositionedDirectional(
              start: _HomeRail.rankInset,
              top: 0,
              child: _HomePoster(
                path: item.posterPath,
                width: posterW,
                height: posterH,
                heroTag: heroTag,
                radius: 14,
              ),
            ),
            PositionedDirectional(
              start: _HomeRail.rankInset,
              end: 0,
              top: posterH + MNSpace.sm,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
