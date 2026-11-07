import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../components/segmented_toggle.dart';
import '../../components/sign_in_prompt.dart';
import '../../design/tokens.dart';
import '../../navigation/routes.dart';
import '../Userpage/Watchlist.dart';
import 'liked.dart';

enum _LibrarySection { liked, watchlist }

/// The Library tab: Liked | Watchlist behind one segmented toggle.
///
/// The bodies are the existing [Liked] and [UserWatchlist] pages for now;
/// Task 11 replaces them with `LikedView` / `WatchlistView`.
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
          if (!widget.isSignedIn)
            SliverFillRemaining(
              hasScrollBody: false,
              child: SignInPrompt(onLogIn: () => presentSignIn(context)),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: MNSpace.lg,
                  vertical: MNSpace.sm,
                ),
                child: SegmentedToggle<_LibrarySection>(
                  segments: [
                    (_LibrarySection.liked, s.libraryLiked),
                    (_LibrarySection.watchlist, s.libraryWatchlist),
                  ],
                  selected: _section,
                  onChanged: (v) => setState(() => _section = v),
                ),
              ),
            ),
            SliverFillRemaining(
              child: switch (_section) {
                _LibrarySection.liked => const Liked(),
                _LibrarySection.watchlist => UserWatchlist(),
              },
            ),
          ],
        ],
      ),
    );
  }
}
