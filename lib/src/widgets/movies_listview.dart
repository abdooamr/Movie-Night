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
  }) : super(key: key);

  final String headlineText;
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
              else
                _HorizontalRail(
                  items: results.take(MoviesListView.maxCount).toList(),
                  size: size,
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
