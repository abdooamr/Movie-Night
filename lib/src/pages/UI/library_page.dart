import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../components/large_title_bar.dart';
import '../../components/segmented_toggle.dart';
import '../../components/state_views.dart';
import '../../design/tokens.dart';
import '../../navigation/routes.dart';
import '../../widgets/library_grid.dart';
import '../Userpage/Watchlist.dart';
import 'liked.dart';

enum _Shelf { watchlist, liked }

/// The Library tab: two shelves of posters, Watchlist (what to watch next)
/// and Liked (what you loved), behind one switch, with a filter for movies
/// or TV shows in the bar.
///
/// Both shelves stay built while the tab is, so switching is instant and
/// never reloads. Liked works signed out (likes are on the device); the
/// Watchlist lives in the account, so signed out it explains that and
/// offers Log In.
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key, required this.isSignedIn});

  final bool isSignedIn;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  // Signed out, open on the shelf that works without an account.
  late _Shelf _shelf = widget.isSignedIn ? _Shelf.watchlist : _Shelf.liked;
  LibraryFilter _filter = LibraryFilter.all;

  void _select(_Shelf shelf) {
    setState(() => _shelf = shelf);
    // Each shelf starts at its top, not at the other one's scroll offset.
    final scroll = PrimaryScrollController.maybeOf(context);
    if (scroll != null && scroll.hasClients && scroll.offset > 0) {
      scroll.jumpTo(0);
    }
  }

  void _showAll() => setState(() => _filter = LibraryFilter.all);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final watchlist = widget.isSignedIn
        ? WatchlistView(filter: _filter, onShowAll: _showAll)
        : SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: IconsaxOutline.bookmark,
              title: s.watchlistSignInTitle,
              body: s.watchlistSignInBody,
              actionLabel: s.loginbuttonlabel,
              onAction: () => presentSignIn(context),
            ),
          );
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: [
          LargeTitleBar(
            title: s.likednavbar,
            actions: [
              _FilterButton(
                filter: _filter,
                onChanged: (f) => setState(() => _filter = f),
              ),
              const SizedBox(width: MNSpace.xs),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  MNSpace.lg, 0, MNSpace.lg, MNSpace.md),
              child: SegmentedToggle<_Shelf>(
                expand: true,
                segments: [
                  (_Shelf.watchlist, s.libraryWatchlist),
                  (_Shelf.liked, s.libraryLiked),
                ],
                selected: _shelf,
                onChanged: _select,
              ),
            ),
          ),
          // Both stay built; only the selected one takes room and paints.
          SliverOffstage(
            offstage: _shelf != _Shelf.watchlist,
            sliver: watchlist,
          ),
          SliverOffstage(
            offstage: _shelf != _Shelf.liked,
            sliver: LikedView(filter: _filter, onShowAll: _showAll),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.paddingOf(context).bottom + MNSpace.xl,
            ),
          ),
        ],
      ),
    );
  }
}

/// The bar's filter menu: All / Movies / TV Shows, with a check on the
/// current one. Tinted while a filter is on, so it is never hidden state.
class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.filter, required this.onChanged});

  final LibraryFilter filter;
  final ValueChanged<LibraryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final cs = Theme.of(context).colorScheme;
    final active = filter != LibraryFilter.all;
    final labels = {
      LibraryFilter.all: s.filterAll,
      LibraryFilter.movies: s.movieswitch,
      LibraryFilter.tv: s.tvswitch,
    };
    return PopupMenuButton<LibraryFilter>(
      tooltip: s.filterLabel,
      initialValue: filter,
      onSelected: onChanged,
      icon: Icon(
        Icons.filter_list_rounded,
        color: active ? cs.primary : null,
        semanticLabel:
            active ? '${s.filterLabel}: ${labels[filter]}' : s.filterLabel,
      ),
      itemBuilder: (context) => [
        for (final f in LibraryFilter.values)
          CheckedPopupMenuItem<LibraryFilter>(
            value: f,
            checked: f == filter,
            child: Text(labels[f]!),
          ),
      ],
    );
  }
}
