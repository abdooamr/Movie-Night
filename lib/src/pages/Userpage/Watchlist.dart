import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/widgets/shimmerWidgets/watchListShimmerWidget.dart';
import 'package:Movie_Night/src/widgets/watchlistwidget.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class userwatchlist extends StatefulWidget {
  @override
  State<userwatchlist> createState() => _userwatchlistState();
}

class _userwatchlistState extends State<userwatchlist>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late DropdownProvider dropdownProvider;

  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return const WatchlistShimmerTile();
      },
    );
  }

  Widget _buildWatchlist(bool isTvShow) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildShimmerList();
        }

        final userData = snapshot.data!.data();
        final watchlist =
            (userData?[isTvShow ? 'tvwatchlist' : 'Moviewatchlist']
                        as List<dynamic>?)
                    ?.cast<int>() ??
                [];

        if (watchlist.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                isTvShow
                    ? S.of(context).notvshowsinwatchlist
                    : S.of(context).nomoviesinwatchlist,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: watchlist.length,
          itemBuilder: (context, index) {
            final movieId = watchlist[index];

            return FutureBuilder<MovieModel>(
              future:
                  getdetails(movieId, isTvShow, dropdownProvider.selectedValue),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const WatchlistShimmerTile();
                }

                if (snapshot.hasError) {
                  return const SizedBox();
                }

                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final movieDetails = snapshot.data!;

                return BookmarkWidget(
                  movieDetails: movieDetails,
                  isTvShow: isTvShow,
                  onPressDelete: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      isTvShow ? 'tvwatchlist' : 'Moviewatchlist':
                          FieldValue.arrayRemove([movieId])
                    });
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).watchlistlabel),
        bottom: TabBar(
          indicatorColor: Colors.deepPurpleAccent,
          controller: _tabController,
          tabs: [
            Tab(text: S.of(context).movieswitch),
            Tab(text: S.of(context).tvswitch),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWatchlist(false), // Movies
          _buildWatchlist(true), // TV Shows
        ],
      ),
    );
  }
}
