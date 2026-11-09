import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../components/segmented_toggle.dart';
import '../../components/state_views.dart';
import '../../design/tokens.dart';
import '../../navigation/routes.dart';
import '../Userpage/Watchlist.dart';
import 'liked.dart';

enum _LibrarySection { liked, watchlist }

/// The Library tab: Liked | Watchlist behind one segmented toggle.
///
/// Liked titles live on the device, so they work signed out. The watchlist
/// lives in the account: signed out, that segment explains why and offers
/// Log In.
///
/// The bodies are [LikedView] and [WatchlistView] slivers inside this one
/// scroll view, so there is a single header.
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key, required this.isSignedIn});

  final bool isSignedIn;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  _LibrarySection _section = _LibrarySection.liked;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Semantics(header: true, child: Text(s.likednavbar)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: MNSpace.lg,
                vertical: MNSpace.sm,
              ),
              child: SegmentedToggle<_LibrarySection>(
                expand: true,
                segments: [
                  (_LibrarySection.liked, s.libraryLiked),
                  (_LibrarySection.watchlist, s.libraryWatchlist),
                ],
                selected: _section,
                onChanged: (v) => setState(() => _section = v),
              ),
            ),
          ),
          switch (_section) {
            _LibrarySection.liked => const LikedView(),
            _LibrarySection.watchlist when widget.isSignedIn =>
              const WatchlistView(),
            _LibrarySection.watchlist => SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: IconsaxOutline.bookmark,
                  title: s.watchlistSignInTitle,
                  body: s.watchlistSignInBody,
                  actionLabel: s.loginbuttonlabel,
                  onAction: () => presentSignIn(context),
                ),
              ),
          },
        ],
      ),
    );
  }
}
