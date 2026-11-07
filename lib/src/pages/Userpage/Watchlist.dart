import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/data/tmdb_repository.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/widgets/shimmerWidgets/watchListShimmerWidget.dart';
import 'package:Movie_Night/src/widgets/watchlistwidget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class UserWatchlist extends StatefulWidget {
  @override
  State<UserWatchlist> createState() => _userwatchlistState();
}

class _userwatchlistState extends State<UserWatchlist>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late DropdownProvider dropdownProvider;

  final UserRepository _users = UserRepository.instance;
  final TmdbRepository _tmdb = TmdbRepository.instance;

  // Created once: a `.snapshots()` call in build() would resubscribe on
  // every rebuild.
  late final Stream<List<int>> _movieIds =
      _users.watchlistStream(isTvShow: false);
  late final Stream<List<int>> _tvIds = _users.watchlistStream(isTvShow: true);

  // One details Future per (title, lang): a Firestore snapshot or a scroll
  // rebuild reuses it instead of refetching every tile (H6).
  final Map<String, Future<MovieModel>> _details = {};

  Future<MovieModel> _detailsFor(int id, bool isTvShow) {
    final lang = dropdownProvider.selectedValue;
    final key = '${isTvShow ? 'tv' : 'movie'}/$id/$lang';
    return _details.putIfAbsent(key, () {
      final f = _tmdb.details(id, isTvShow, lang);
      // Forget failures so the next snapshot/rebuild retries that tile.
      f.then<void>((_) {}, onError: (Object _) => _details.remove(key));
      return f;
    });
  }

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
    return StreamBuilder<List<int>>(
      stream: isTvShow ? _tvIds : _movieIds,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildShimmerList();
        }

        final watchlist = snapshot.data!;

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
              key: ValueKey('${isTvShow ? 'tv' : 'movie'}/$movieId'),
              future: _detailsFor(movieId, isTvShow),
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
                    _users.removeFromWatchlist(movieId, isTvShow: isTvShow);
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
