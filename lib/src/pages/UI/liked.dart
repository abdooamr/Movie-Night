import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../Provider/langprovider.dart';
import '../../components/cached_image.dart';
import '../../components/feedback.dart';
import '../../components/poster_card.dart';
import '../../components/rating_badge.dart';
import '../../components/state_views.dart';
import '../../design/motion.dart';
import '../../design/tokens.dart';
import '../../models/liked_model.dart';
import '../../models/movie_model.dart';
import '../../navigation/routes.dart';
import '../../services/services.dart';
import '../../utils/poster_size.dart';
import '../../utils/utils.dart' show imageUrl;
import '../../widgets/Navbar/Navbar.dart';

/// The Liked section of the Library tab, as slivers (no Scaffold or AppBar of
/// its own, so it never adds a second header).
///
/// Compact widths: a carousel over a cross-fading backdrop with a dot
/// indicator. Regular widths (600 pt and up): a grid of poster cards.
/// Removing a title is immediate, with an Undo snackbar (B4).
class LikedView extends StatefulWidget {
  const LikedView({super.key, this.box});

  /// Test hook; defaults to the app's `liked` Hive box.
  final Box<LikedModel>? box;

  @override
  State<LikedView> createState() => _LikedViewState();
}

class _LikedViewState extends State<LikedView> {
  late final Box<LikedModel> _box;
  int _index = 0;

  /// Memoized media-type lookups for legacy entries saved before
  /// [LikedModel.isTvShow] existed. Keyed by movie id; at most one request
  /// per entry, and only when the user taps it.
  final Map<int, Future<bool>> _isTvShowCache = {};

  @override
  void initState() {
    super.initState();
    _box = widget.box ?? Hive.box<LikedModel>('liked');
    // One-time cleanup of entries un-liked by older app versions, which
    // stored isLiked=false instead of deleting. Done after the first frame so
    // the box is never mutated while the builder is iterating it.
    WidgetsBinding.instance.addPostFrameCallback((_) => _sweepUnliked());
  }

  void _sweepUnliked() {
    if (!_box.isOpen) return;
    final staleKeys = _box.keys.where((k) => !(_box.get(k)?.isLiked ?? false));
    if (staleKeys.isNotEmpty) _box.deleteAll(staleKeys.toList());
  }

  Future<bool> _resolveIsTvShow(LikedModel liked, String lang) {
    return _isTvShowCache.putIfAbsent(liked.id, () async {
      final result = await searchData(liked.title, lang);
      final isTv = result.results.first.mediaType == MediaType.tv;
      // Back-fill so this entry never needs a lookup again.
      liked.isTvShow = isTv;
      await liked.save();
      return isTv;
    })
      // Drop failed lookups so a later tap can retry.
      ..catchError((Object _) {
        _isTvShowCache.remove(liked.id);
        return false;
      });
  }

  Future<void> _openDetails(LikedModel liked) async {
    final lang = context.read<DropdownProvider>().selectedValue;
    final bool isTv;
    try {
      isTv = liked.isTvShow ?? await _resolveIsTvShow(liked, lang);
    } catch (e) {
      if (!mounted) return;
      AppFeedback.error(context, '${S.of(context).error}: $e');
      return;
    }
    if (!mounted) return;
    openTitle(
      context,
      id: liked.id,
      isTv: isTv,
      heroTag: heroTagFor(source: 'liked', isTv: isTv, id: liked.id),
    );
  }

  /// Removes at once and offers Undo, which puts a copy back under the same
  /// key (B4).
  void _remove(LikedModel liked) {
    final key = liked.key;
    final copy = LikedModel(
      isLiked: liked.isLiked,
      title: liked.title,
      genres: liked.genres,
      voteAverage: liked.voteAverage,
      posterPath: liked.posterPath,
      id: liked.id,
      isTvShow: liked.isTvShow,
    );
    final box = _box;
    box.delete(key);
    AppFeedback.undo(
      context,
      S.of(context).removedFromLiked,
      onUndo: () {
        if (box.isOpen) box.put(key, copy);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<LikedModel>>(
      valueListenable: _box.listenable(),
      builder: (context, box, _) {
        final items = box.values.where((e) => e.isLiked).toList();
        if (items.isEmpty) return const _EmptyLiked();
        _index = math.min(_index, items.length - 1);

        final bottom = MediaQuery.paddingOf(context).bottom + MNSpace.lg;
        final regular =
            MediaQuery.sizeOf(context).width >= PosterSize.tabletBreakpoint;
        if (regular) return _grid(context, items, bottom);
        return SliverMainAxisGroup(
          slivers: [
            SliverLayoutBuilder(
              builder: (context, constraints) {
                final height = math.min(
                  constraints.viewportMainAxisExtent * 0.75,
                  520.0,
                );
                return SliverToBoxAdapter(
                  child: _LikedCarousel(
                    // A new key restarts the pager at the clamped page when
                    // the number of items changes (remove / undo).
                    key: ValueKey(items.length),
                    items: items,
                    height: height,
                    initialIndex: _index,
                    onIndex: (i) => setState(() => _index = i),
                    onOpen: _openDetails,
                    onRemove: _remove,
                  ),
                );
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: bottom)),
          ],
        );
      },
    );
  }

  Widget _grid(BuildContext context, List<LikedModel> items, double bottom) {
    final size = PosterSize.of(context);
    final tooltip = S.of(context).deleteBookmark;
    return SliverPadding(
      padding: EdgeInsetsDirectional.fromSTEB(
        MNSpace.lg,
        MNSpace.sm,
        MNSpace.lg,
        bottom,
      ),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: size.width + MNSpace.md,
          mainAxisExtent: size.cardHeight,
          mainAxisSpacing: MNSpace.lg,
          crossAxisSpacing: MNSpace.md,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final liked = items[i];
          final isTv = liked.isTvShow ?? false;
          return Stack(
            children: [
              PosterCard(
                posterPath: liked.posterPath.isEmpty ? null : liked.posterPath,
                title: liked.title,
                subtitle: liked.genres,
                heroTag: heroTagFor(source: 'liked', isTv: isTv, id: liked.id),
                onTap: () => _openDetails(liked),
              ),
              PositionedDirectional(
                top: 0,
                end: 0,
                child: IconButton.filledTonal(
                  tooltip: tooltip,
                  onPressed: () => _remove(liked),
                  icon: const Icon(IconsaxOutline.trash),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LikedCarousel extends StatelessWidget {
  const _LikedCarousel({
    super.key,
    required this.items,
    required this.height,
    required this.initialIndex,
    required this.onIndex,
    required this.onOpen,
    required this.onRemove,
  });

  final List<LikedModel> items;
  final double height;
  final int initialIndex;
  final ValueChanged<int> onIndex;
  final ValueChanged<LikedModel> onOpen;
  final ValueChanged<LikedModel> onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final motion = MNMotion.of(context);
    final current = math.min(initialIndex, items.length - 1);
    return Column(
      children: [
        SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: motion.fade(MNDuration.medium),
                  child: _Backdrop(
                    key: ValueKey(current),
                    posterPath: items[current].posterPath,
                  ),
                ),
              ),
              CarouselSlider.builder(
                itemCount: items.length,
                options: CarouselOptions(
                  height: height,
                  initialPage: current,
                  viewportFraction: 0.72,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: items.length > 1 && motion.allowRichMotion,
                  onPageChanged: (i, _) => onIndex(i),
                ),
                itemBuilder: (context, i, _) => Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: MNSpace.xs,
                    vertical: MNSpace.lg,
                  ),
                  child: _LikedCard(
                    liked: items[i],
                    onTap: () => onOpen(items[i]),
                    onRemove: () => onRemove(items[i]),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: MNSpace.sm),
        ExcludeSemantics(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: MNSpace.sm,
            runSpacing: MNSpace.sm,
            children: [
              for (var i = 0; i < items.length; i++)
                DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    color: i == current
                        ? cs.primary
                        : cs.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  child: const SizedBox.square(dimension: MNSpace.sm),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Decorative blurred-by-fade poster behind the carousel; fades into the
/// surface at the bottom.
class _Backdrop extends StatelessWidget {
  const _Backdrop({super.key, required this.posterPath});

  final String posterPath;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return ExcludeSemantics(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (posterPath.isNotEmpty)
            Opacity(
              opacity: 0.35,
              child: CachedImageCustom('$imageUrl$posterPath'),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [surface.withValues(alpha: 0), surface],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LikedCard extends StatelessWidget {
  const _LikedCard({
    required this.liked,
    required this.onTap,
    required this.onRemove,
  });

  final LikedModel liked;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isTv = liked.isTvShow ?? false;
    return Material(
      color: cs.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(borderRadius: MNRadius.lgAll),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Semantics(
              button: true,
              label: liked.title,
              excludeSemantics: true,
              onTap: onTap,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    MNSpace.md,
                    MNSpace.md,
                    MNSpace.md,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: Hero(
                            tag: heroTagFor(
                              source: 'liked',
                              isTv: isTv,
                              id: liked.id,
                            ),
                            child: ClipRRect(
                              borderRadius: MNRadius.mdAll,
                              child: liked.posterPath.isEmpty
                                  ? ColoredBox(
                                      color: cs.surfaceContainer,
                                      child: Icon(
                                        IconsaxOutline.video,
                                        color: cs.onSurfaceVariant,
                                      ),
                                    )
                                  : CachedImageCustom(
                                      '$imageUrl${liked.posterPath}',
                                      decodeWidth: PosterSize.of(context).width,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: MNSpace.sm),
                      Text(
                        liked.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        liked.genres,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium!
                            .copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: MNSpace.md,
              end: MNSpace.xs,
            ),
            child: Row(
              children: [
                RatingBadge(score: liked.voteAverage),
                const Spacer(),
                IconButton(
                  tooltip: S.of(context).deleteBookmark,
                  onPressed: onRemove,
                  icon: const Icon(IconsaxOutline.trash),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLiked extends StatelessWidget {
  const _EmptyLiked();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyState(
        icon: IconsaxOutline.heart,
        title: s.nolikedmovies,
        body: s.likedEmptyBody,
        actionLabel: s.browseMovies,
        onAction: () => AppShell.maybeOf(context)?.selectTab(0),
      ),
    );
  }
}
