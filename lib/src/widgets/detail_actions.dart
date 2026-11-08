import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_icons/simple_icons.dart';

import '../../generated/l10n.dart';
import '../components/action_tile.dart';
import '../design/tokens.dart';

/// Brand name of the external link; a trademark, not translated.
const String _imdbLabel = 'IMDb';

/// Detail's action block: the one primary action ("Watch Trailers") and a row
/// of tonal [ActionTile]s (Like, Watchlist, IMDb).
///
/// Signed out, Like and Watchlist call [onRequireSignIn] instead of acting;
/// IMDb always works. Data access stays with the caller: [onToggleLike]
/// writes the like, and [watchlist] is the signed-in watchlist tile (it owns
/// its own reads and writes).
class DetailActions extends StatelessWidget {
  const DetailActions({
    super.key,
    required this.isLoggedIn,
    required this.isLiked,
    required this.onToggleLike,
    required this.onRequireSignIn,
    required this.onWatchTrailers,
    this.onOpenImdb,
    this.watchlist,
  });

  final bool isLoggedIn;
  final bool isLiked;
  final VoidCallback onToggleLike;
  final VoidCallback onRequireSignIn;
  final VoidCallback onWatchTrailers;

  /// Opens the title on IMDb; null (no IMDb id) hides the tile.
  final VoidCallback? onOpenImdb;

  /// Signed-in watchlist tile. When null, or signed out, a tile that asks
  /// the user to sign in is shown instead.
  final Widget? watchlist;

  void _like() {
    HapticFeedback.lightImpact();
    onToggleLike();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final tiles = <Widget>[
      ActionTile(
        icon: IconsaxOutline.heart,
        selectedIcon: IconsaxBold.heart,
        label: isLoggedIn && isLiked ? s.liked : s.like,
        selected: isLoggedIn && isLiked,
        onTap: isLoggedIn ? _like : onRequireSignIn,
      ),
      if (isLoggedIn && watchlist != null)
        watchlist!
      else
        ActionTile(
          icon: IconsaxOutline.bookmark,
          selectedIcon: IconsaxBold.bookmark,
          label: s.addtowatchlist,
          onTap: onRequireSignIn,
        ),
      if (onOpenImdb != null)
        ActionTile(
          icon: SimpleIcons.imdb,
          label: _imdbLabel,
          onTap: onOpenImdb!,
        ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: onWatchTrailers,
          icon: const Icon(IconsaxOutline.video_play),
          label: Text(s.watchTrailers),
        ),
        const SizedBox(height: MNSpace.md),
        // Equal-height tiles even when one label wraps.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0) const SizedBox(width: MNSpace.sm),
                Expanded(child: tiles[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// The app bar's Share action. Available signed in or out.
class DetailShareButton extends StatelessWidget {
  const DetailShareButton({super.key, required this.onShare});

  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: S.of(context).share,
      onPressed: onShare,
      icon: const Icon(IconsaxOutline.export_1),
    );
  }
}
