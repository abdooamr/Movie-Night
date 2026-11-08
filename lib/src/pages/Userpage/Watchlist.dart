import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../Provider/langprovider.dart';
import '../../components/feedback.dart';
import '../../components/segmented_toggle.dart';
import '../../components/state_views.dart';
import '../../data/tmdb_repository.dart';
import '../../data/user_repository.dart';
import '../../design/tokens.dart';
import '../../models/moviedetails.dart';
import '../../widgets/Navbar/Navbar.dart';
import '../../widgets/shimmerWidgets/watchListShimmerWidget.dart';
import '../../widgets/watchlistwidget.dart';

enum _Kind { movies, tv }

/// The Watchlist section of the Library tab, as slivers (no Scaffold or
/// AppBar of its own): a Movies | TV Shows toggle, then the saved titles.
/// Removal is immediate, with an Undo snackbar (B4).
class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  final UserRepository _users = UserRepository.instance;
  final TmdbRepository _tmdb = TmdbRepository.instance;

  _Kind _kind = _Kind.movies;

  // Created once (and again on retry): a `.snapshots()` call in build()
  // would resubscribe on every rebuild.
  late Stream<List<int>> _movieIds = _users.watchlistStream(isTvShow: false);
  late Stream<List<int>> _tvIds = _users.watchlistStream(isTvShow: true);

  // One details Future per (title, lang): a Firestore snapshot or a scroll
  // rebuild reuses it instead of refetching every tile (H6).
  final Map<String, Future<MovieModel>> _details = {};

  String _keyFor(int id, bool isTv, String lang) =>
      '${isTv ? 'tv' : 'movie'}/$id/$lang';

  Future<MovieModel> _detailsFor(int id, bool isTv) {
    final lang = context.read<DropdownProvider>().selectedValue;
    final key = _keyFor(id, isTv, lang);
    return _details.putIfAbsent(key, () {
      final f = _tmdb.details(id, isTv, lang);
      // Forget failures so a retry or the next snapshot refetches that row.
      f.then<void>((_) {}, onError: (Object _) => _details.remove(key));
      return f;
    });
  }

  void _retryRow(int id, bool isTv) {
    final lang = context.read<DropdownProvider>().selectedValue;
    setState(() => _details.remove(_keyFor(id, isTv, lang)));
  }

  void _retryStream() => setState(() {
        _movieIds = _users.watchlistStream(isTvShow: false);
        _tvIds = _users.watchlistStream(isTvShow: true);
      });

  Future<void> _remove(int id, bool isTv) async {
    final s = S.of(context);
    try {
      await _users.removeFromWatchlist(id, isTvShow: isTv);
    } catch (_) {
      if (mounted) AppFeedback.error(context, s.error);
      return;
    }
    if (!mounted) return;
    AppFeedback.undo(
      context,
      s.removedFromWatchlist,
      onUndo: () async {
        try {
          await _users.addToWatchlist(id, isTvShow: isTv);
        } catch (_) {
          if (mounted) AppFeedback.error(context, s.error);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isTv = _kind == _Kind.tv;
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: MNSpace.lg,
              vertical: MNSpace.sm,
            ),
            child: SegmentedToggle<_Kind>(
              segments: [
                (_Kind.movies, s.movieswitch),
                (_Kind.tv, s.tvswitch),
              ],
              selected: _kind,
              onChanged: (v) => setState(() => _kind = v),
            ),
          ),
        ),
        StreamBuilder<List<int>>(
          // A new key per kind so each list starts from its own snapshot.
          key: ValueKey(_kind),
          stream: isTv ? _tvIds : _movieIds,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorState(
                  message: s.error,
                  onRetry: _retryStream,
                ),
              );
            }
            if (!snapshot.hasData) return _shimmerList();
            final ids = snapshot.data!;
            if (ids.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: IconsaxOutline.bookmark,
                  title:
                      isTv ? s.notvshowsinwatchlist : s.nomoviesinwatchlist,
                  body: s.watchlistEmptyBody,
                  actionLabel: s.browseMovies,
                  onAction: () => AppShell.maybeOf(context)?.selectTab(0),
                ),
              );
            }
            return SliverPadding(
              padding: EdgeInsetsDirectional.only(
                bottom: MediaQuery.paddingOf(context).bottom + MNSpace.lg,
              ),
              sliver: SliverList.builder(
                itemCount: ids.length,
                itemBuilder: (context, index) => _row(ids[index], isTv),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _shimmerList() => SliverList.builder(
        itemCount: 4,
        itemBuilder: (context, _) => const WatchlistShimmerTile(),
      );

  Widget _row(int id, bool isTv) {
    return FutureBuilder<MovieModel>(
      key: ValueKey('${isTv ? 'tv' : 'movie'}/$id'),
      future: _detailsFor(id, isTv),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: MNSpace.sm,
            ),
            child: ErrorState(
              compact: true,
              message: S.of(context).error,
              onRetry: () => _retryRow(id, isTv),
            ),
          );
        }
        final details = snapshot.data;
        if (details == null) return const WatchlistShimmerTile();
        return BookmarkWidget(
          movieDetails: details,
          isTvShow: isTv,
          onRemove: () => _remove(id, isTv),
        );
      },
    );
  }
}
