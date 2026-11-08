import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/action_tile.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ficonsax/ficonsax.dart';

/// Signed-in Watchlist toggle tile on Detail. Bookmark outline at rest, bold
/// when saved. Optimistic: flips at once (light haptic) and rolls back with a
/// heavy haptic and an error snackbar if the write fails.
class Watchlistwidget extends StatefulWidget {
  final int movieid;
  final bool istvshow;

  const Watchlistwidget(
      {super.key, required this.movieid, required this.istvshow});

  @override
  State<Watchlistwidget> createState() => _WatchlistwidgetState();
}

class _WatchlistwidgetState extends State<Watchlistwidget> {
  final UserRepository _users = UserRepository.instance;

  bool isInWatchlist = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _checkIfMovieInWatchlist();
  }

  Future<void> _checkIfMovieInWatchlist() async {
    try {
      final inList =
          await _users.isInWatchlist(widget.movieid, isTvShow: widget.istvshow);
      if (mounted) setState(() => isInWatchlist = inList);
    } catch (_) {
      // Leave the default (not in watchlist) if the read fails.
    }
  }

  Future<void> _toggleWatchlist() async {
    if (_busy) return;
    _busy = true;
    final adding = !isInWatchlist;
    // Optimistic: flip now, roll back if the write fails.
    HapticFeedback.lightImpact();
    setState(() => isInWatchlist = adding);
    try {
      if (adding) {
        await _users.addToWatchlist(widget.movieid, isTvShow: widget.istvshow);
      } else {
        await _users.removeFromWatchlist(widget.movieid,
            isTvShow: widget.istvshow);
      }
    } catch (_) {
      if (mounted) {
        setState(() => isInWatchlist = !adding);
        HapticFeedback.heavyImpact();
        AppFeedback.error(context, S.of(context).watchlistUpdateFailed);
      }
    } finally {
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActionTile(
      icon: IconsaxOutline.bookmark,
      selectedIcon: IconsaxBold.bookmark,
      selected: isInWatchlist,
      label: isInWatchlist
          ? S.of(context).inWatchlist
          : S.of(context).addtowatchlist,
      onTap: _toggleWatchlist,
    );
  }
}
