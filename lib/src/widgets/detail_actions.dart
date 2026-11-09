import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/l10n.dart';
import '../components/action_tile.dart';
import '../design/tokens.dart';

/// Detail's action block: the one primary action ("Watch Trailers") and a row
/// of three tonal [ActionTile]s: Like, Watchlist, Share. (IMDb, an external
/// link, lives in [DetailMoreMenu].)
///
/// Like and Share work signed in or out (likes are stored on the device).
/// Signed out, Watchlist calls [onRequireSignIn] instead of acting. Data access stays with the caller: [onToggleLike]
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
    required this.onShare,
    this.watchlist,
  });

  final bool isLoggedIn;
  final bool isLiked;
  final VoidCallback onToggleLike;
  final VoidCallback onRequireSignIn;
  final VoidCallback onWatchTrailers;

  /// Opens the share sheet.
  final VoidCallback onShare;

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
        label: isLiked ? s.liked : s.like,
        selected: isLiked,
        onTap: _like,
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
      ActionTile(
        icon: IconsaxOutline.export_1,
        label: s.share,
        onTap: onShare,
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

enum _MoreAction { share, imdb }

/// The app bar's "⋯" menu: Share (also reachable once the tiles have
/// scrolled away) and Open in IMDb when the title has an IMDb id.
class DetailMoreMenu extends StatelessWidget {
  const DetailMoreMenu({super.key, required this.onShare, this.onOpenImdb});

  final VoidCallback onShare;

  /// Null (no IMDb id) leaves the item out.
  final VoidCallback? onOpenImdb;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PopupMenuButton<_MoreAction>(
      icon: const Icon(IconsaxOutline.more),
      onSelected: (a) => switch (a) {
        _MoreAction.share => onShare(),
        _MoreAction.imdb => onOpenImdb?.call(),
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MoreAction.share,
          child: ListTile(
            contentPadding: EdgeInsetsDirectional.zero,
            leading: const Icon(IconsaxOutline.export_1),
            title: Text(s.share),
          ),
        ),
        if (onOpenImdb != null)
          PopupMenuItem(
            value: _MoreAction.imdb,
            child: ListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              leading: const Icon(IconsaxOutline.export_3),
              title: Text(s.openInImdb),
            ),
          ),
      ],
    );
  }
}
