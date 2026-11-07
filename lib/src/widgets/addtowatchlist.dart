import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/squaretile.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:ficonsax/ficonsax.dart';

class Watchlistwidget extends StatefulWidget {
  final int movieid;
  final bool istvshow;

  Watchlistwidget({required this.movieid, required this.istvshow});

  @override
  _WatchlistwidgetState createState() => _WatchlistwidgetState();
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
    setState(() => isInWatchlist = adding);
    try {
      if (adding) {
        await _users.addToWatchlist(widget.movieid, isTvShow: widget.istvshow);
      } else {
        await _users.removeFromWatchlist(widget.movieid,
            isTvShow: widget.istvshow);
      }
    } catch (_) {
      if (mounted) setState(() => isInWatchlist = !adding);
    } finally {
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SquareTile(
      icon: isInWatchlist ? IconsaxBold.trash : IconsaxBold.bookmark,
      label: isInWatchlist
          ? S.of(context).removefromwatchlist
          : S.of(context).addtowatchlist,
      onTap: _toggleWatchlist,
    );
  }
}
