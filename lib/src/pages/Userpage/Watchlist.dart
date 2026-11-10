import 'dart:async';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../Provider/langprovider.dart';
import '../../components/feedback.dart';
import '../../components/poster_card.dart';
import '../../components/state_views.dart';
import '../../data/tmdb_repository.dart';
import '../../data/user_repository.dart';
import '../../models/moviedetails.dart';
import '../../navigation/routes.dart';
import '../../pages/UI/detail_preview.dart';
import '../../widgets/Navbar/Navbar.dart';
import '../../widgets/library_grid.dart';

/// The Watchlist shelf of the Library tab, as slivers: a count, then a
/// poster grid of movies and shows, most recently added first. Long-press a
/// poster to remove it (with Undo).
///
/// One subscription for the life of the view (the Library keeps it alive
/// while the other shelf shows), so switching shelves never reloads. After
/// the first load, a failed reload keeps the list on screen.
class WatchlistView extends StatefulWidget {
  const WatchlistView({
    super.key,
    this.filter = LibraryFilter.all,
    this.onShowAll,
  });

  final LibraryFilter filter;

  /// Clears the filter (from the "no matches" state).
  final VoidCallback? onShowAll;

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  final UserRepository _users = UserRepository.instance;
  final TmdbRepository _tmdb = TmdbRepository.instance;

  StreamSubscription<List<WatchlistEntry>>? _sub;
  List<WatchlistEntry>? _entries;
  bool _failed = false;

  /// One details Future per (title, lang): a list update or a scroll rebuild
  /// reuses it instead of refetching every poster.
  final Map<String, Future<MovieModel>> _details = {};

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    _sub = _users.watchlistEntries().listen(
      (entries) {
        if (mounted) {
          setState(() {
            _entries = entries;
            _failed = false;
          });
        }
      },
      onError: (Object _) {
        // Only worth showing when there is nothing to show instead.
        if (mounted && _entries == null) setState(() => _failed = true);
      },
    );
  }

  void _retry() {
    setState(() => _failed = false);
    _subscribe();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  String _keyFor(WatchlistEntry e, String lang) =>
      '${e.isTv ? 'tv' : 'movie'}/${e.tmdbId}/$lang';

  Future<MovieModel> _detailsFor(WatchlistEntry e) {
    final lang = context.read<DropdownProvider>().selectedValue;
    final key = _keyFor(e, lang);
    return _details.putIfAbsent(key, () {
      final f = _tmdb.details(e.tmdbId, e.isTv, lang);
      // Forget failures so a tap on the tile refetches it.
      f.then<void>((_) {}, onError: (Object _) {
        _details.remove(key);
      });
      return f;
    });
  }

  void _retryTile(WatchlistEntry e) {
    final lang = context.read<DropdownProvider>().selectedValue;
    setState(() {
      _details.remove(_keyFor(e, lang));
    });
  }

  Future<void> _remove(WatchlistEntry e) async {
    final s = S.of(context);
    try {
      await _users.removeFromWatchlist(e.tmdbId, isTvShow: e.isTv);
    } catch (_) {
      if (mounted) AppFeedback.error(context, s.watchlistUpdateFailed);
      return;
    }
    if (!mounted) return;
    AppFeedback.undo(
      context,
      s.removedFromWatchlist,
      onUndo: () async {
        try {
          await _users.addToWatchlist(e.tmdbId, isTvShow: e.isTv);
        } catch (_) {
          if (mounted) AppFeedback.error(context, s.watchlistUpdateFailed);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final entries = _entries;
    if (entries == null) {
      if (_failed) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorState(message: s.genericError, onRetry: _retry),
        );
      }
      return const LibraryGridSkeleton();
    }
    if (entries.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(
          icon: IconsaxOutline.bookmark,
          title: s.watchlistEmptyTitle,
          body: s.watchlistEmptyBody,
          actionLabel: s.browseMovies,
          onAction: () => AppShell.maybeOf(context)?.selectTab(0),
        ),
      );
    }
    final items = [
      for (final e in entries)
        if (widget.filter.keeps(isTv: e.isTv)) e,
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
          itemBuilder: (context, i) => _tile(items[i]),
        ),
      ],
    );
  }

  Widget _tile(WatchlistEntry e) {
    final s = S.of(context);
    return FutureBuilder<MovieModel>(
      key: ValueKey('${e.isTv ? 'tv' : 'movie'}/${e.tmdbId}'),
      future: _detailsFor(e),
      builder: (context, snapshot) {
        final details = snapshot.data;
        if (snapshot.hasError && details == null) {
          // A quiet tile instead of an error box per poster.
          return PosterCard(
            posterPath: null,
            title: s.tryAgain,
            onTap: () => _retryTile(e),
          );
        }
        if (details == null) return const LibraryTileSkeleton();
        final preview = DetailPreview.fromDetails(details, isTv: e.isTv);
        final kind = e.isTv ? s.mediaTvShow : s.mediaMovie;
        final heroTag =
            heroTagFor(source: 'watchlist', isTv: e.isTv, id: e.tmdbId);
        return LibraryTile(
          posterPath: preview.posterPath,
          title: preview.title,
          subtitle: preview.year == null ? kind : '$kind · ${preview.year}',
          heroTag: heroTag,
          onOpen: () => openTitle(
            context,
            id: e.tmdbId,
            isTv: e.isTv,
            heroTag: heroTag,
            preview: preview,
          ),
          removeLabel: s.removefromwatchlist,
          onRemove: () => _remove(e),
        );
      },
    );
  }
}
