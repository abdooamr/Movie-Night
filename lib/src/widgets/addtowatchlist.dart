import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/squaretile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  bool isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    _checkIfMovieInWatchlist();
  }

  Future<void> _checkIfMovieInWatchlist() async {
    final user = await _usersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (user.exists) {
      final watchlistKey = widget.istvshow ? 'tvwatchlist' : 'Moviewatchlist';
      final watchlistData = user.data() as Map<String, dynamic>?;
      final watchlist = watchlistData?[watchlistKey];
      setState(() {
        isInWatchlist = watchlist != null && watchlist.contains(widget.movieid);
      });
    } else {
      setState(() {
        isInWatchlist = false;
      });
    }
  }

  Future<void> _addMovieToWatchlist(int movieId) async {
    final user = await _usersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final watchlistKey = widget.istvshow ? 'tvwatchlist' : 'Moviewatchlist';
    if (user.exists) {
      if (!isInWatchlist) {
        // Update the watchlist using arrayUnion to add the movieId to the existing watchlist.
        user.reference.update({
          watchlistKey: FieldValue.arrayUnion([movieId]),
        });
      } else {
        // Update the watchlist using arrayRemove to remove the movieId from the existing watchlist.
        user.reference.update({
          watchlistKey: FieldValue.arrayRemove([movieId]),
        });
      }
    } else {
      // Create a new user document and add the movie ID to their watchlist.
      await _usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
        watchlistKey: [movieId],
      });
    }
    // Toggle the isInWatchlist state after the update.
    setState(() {
      isInWatchlist = !isInWatchlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SquareTile(
      icon: isInWatchlist ? IconsaxBold.trash : IconsaxBold.bookmark,
      label: isInWatchlist
          ? S.of(context).removefromwatchlist
          : S.of(context).addtowatchlist,
      onTap: () {
        _addMovieToWatchlist(widget.movieid);
      },
    );
  }
}
