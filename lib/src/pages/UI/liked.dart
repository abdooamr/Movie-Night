import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../Provider/langprovider.dart';
import '../../components/feedback.dart';
import '../../components/poster_card.dart' show heroTagFor;
import '../../components/state_views.dart';
import '../../models/liked_model.dart';
import '../../models/movie_model.dart';
import '../../navigation/routes.dart';
import '../../pages/UI/detail_preview.dart';
import '../../services/services.dart';
import '../../widgets/Navbar/Navbar.dart';
import '../../widgets/library_grid.dart';

/// The Liked shelf of the Library tab, as slivers: a count, then a poster
/// grid, newest first. Likes are stored on the device, so this works signed
/// in or out. Long-press a poster to remove it (with Undo).
class LikedView extends StatefulWidget {
  const LikedView({
    super.key,
    this.box,
    this.filter = LibraryFilter.all,
    this.onShowAll,
  });

  /// Test hook; defaults to the app's `liked` Hive box.
  final Box<LikedModel>? box;

  final LibraryFilter filter;

  /// Clears the filter (from the "no matches" state).
  final VoidCallback? onShowAll;

  @override
  State<LikedView> createState() => _LikedViewState();
}

class _LikedViewState extends State<LikedView> {
  late final Box<LikedModel> _box;

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

  Future<void> _open(LikedModel liked) async {
    final lang = context.read<DropdownProvider>().selectedValue;
    final bool isTv;
    try {
      isTv = liked.isTvShow ?? await _resolveIsTvShow(liked, lang);
    } catch (_) {
      if (!mounted) return;
      AppFeedback.error(context, S.of(context).genericError);
      return;
    }
    if (!mounted) return;
    openTitle(
      context,
      id: liked.id,
      isTv: isTv,
      heroTag: heroTagFor(source: 'liked', isTv: isTv, id: liked.id),
      preview: DetailPreview(
        title: liked.title,
        posterPath: liked.posterPath.isEmpty ? null : liked.posterPath,
        voteAverage: liked.voteAverage,
      ),
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
    final s = S.of(context);
    return ValueListenableBuilder<Box<LikedModel>>(
      valueListenable: _box.listenable(),
      builder: (context, box, _) {
        // Newest first. Legacy entries without a type count as movies.
        final all = box.values.where((e) => e.isLiked).toList().reversed;
        if (all.isEmpty) {
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
        final items = [
          for (final e in all)
            if (widget.filter.keeps(isTv: e.isTvShow ?? false)) e,
        ];
        if (items.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: Icons.filter_list_rounded,
              title: s.libraryNoMatches,
              actionLabel: widget.onShowAll == null ? null : s.showAll,
              onAction: widget.onShowAll,
            ),
          );
        }
        return SliverMainAxisGroup(
          slivers: [
            LibraryCount(count: items.length),
            LibraryGrid(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final liked = items[i];
                final isTv = liked.isTvShow ?? false;
                return LibraryTile(
                  key: ValueKey(liked.key),
                  posterPath:
                      liked.posterPath.isEmpty ? null : liked.posterPath,
                  title: liked.title,
                  subtitle: isTv ? s.mediaTvShow : s.mediaMovie,
                  heroTag:
                      heroTagFor(source: 'liked', isTv: isTv, id: liked.id),
                  onOpen: () => _open(liked),
                  removeLabel: s.removeFromLiked,
                  onRemove: () => _remove(liked),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
