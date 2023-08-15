import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/services/services.dart';
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
  late Future<MovieModel> moviedetails;
  late Future<MovieModel> tvshowdetails;
  late DropdownProvider dropdownProvider;

  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');
  bool? isTvShow;
  int? id;
  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    super.initState();
    // moviedetails = getdetails(id!, false, dropdownProvider.selectedValue);
    // tvshowdetails = getdetails(id!, true, dropdownProvider.selectedValue);
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
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
          // Movies tab
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _usersCollection
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data();
                final movieWatchlist =
                    (userData?['Moviewatchlist'] as List<dynamic>?)
                        ?.cast<int>();

                if (movieWatchlist != null && movieWatchlist.isNotEmpty) {
                  return ListView(
                    children: movieWatchlist.map((movieId) {
                      return FutureBuilder<MovieModel>(
                        future: getdetails(
                            movieId, false, dropdownProvider.selectedValue),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final movieDetails = snapshot.data!;
                            return bookmarkwidget(
                                movieDetails: movieDetails, isTvShow: false);
                          } else {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.deepPurpleAccent,
                              strokeWidth: 3,
                            ));
                          }
                        },
                      );
                      // return SquareTile(
                      //   icon: IconsaxBold.bookmark,
                      //   label: movieId.toString(),
                      //   onTap: () {
                      //     // Do something when the movie is tapped.
                      //   },
                      // );
                    }).toList(),
                  );
                } else {
                  return Center(child: Text(S.of(context).nomoviesinwatchlist));
                }
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                  strokeWidth: 3,
                ));
              }
            },
          ),
          // TV shows tab
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _usersCollection
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data();
                final tvShowWatchlist =
                    (userData?['tvwatchlist'] as List<dynamic>?)?.cast<int>();

                if (tvShowWatchlist != null && tvShowWatchlist.isNotEmpty) {
                  return ListView(
                    children: tvShowWatchlist.map((movieId) {
                      return FutureBuilder<MovieModel>(
                        future: getdetails(
                            movieId, true, dropdownProvider.selectedValue),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final movieDetails = snapshot.data!;
                            return bookmarkwidget(
                                movieDetails: movieDetails, isTvShow: true);
                          } else {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.deepPurpleAccent,
                              strokeWidth: 3,
                            ));
                          }
                        },
                      );
                      // return SquareTile(
                      //   icon: IconsaxBold.bookmark,
                      //   label: movieId.toString(),
                      //   onTap: () {
                      //     // Do something when the movie is tapped.
                      //   },
                      // );
                    }).toList(),
                  );
                } else {
                  return Center(
                      child: Text(S.of(context).notvshowsinwatchlist));
                }
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                  strokeWidth: 3,
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
