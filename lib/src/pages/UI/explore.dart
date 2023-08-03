import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/widgets/allwidget.dart';

import '../../models/movie_model.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  late Future<Model> comedyFuture,
      actionFuture,
      horrorFuture,
      dramaFuture,
      romanceFuture,
      familyFuture,
      adventureFuture,
      mysteryFuture,
      scifiFuture,
      warFuture;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 10, vsync: this);

    comedyFuture = discoverMovies(genreId: 35);
    actionFuture = discoverMovies(genreId: 28);
    horrorFuture = discoverMovies(genreId: 27);
    dramaFuture = discoverMovies(genreId: 18);
    familyFuture = discoverMovies(genreId: 10751);
    romanceFuture = discoverMovies(genreId: 10749);
    adventureFuture = discoverMovies(genreId: 12);
    mysteryFuture = discoverMovies(genreId: 9648);
    scifiFuture = discoverMovies(genreId: 878);
    warFuture = discoverMovies(genreId: 10752);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30), // Add spacing here
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: Search(),
                );
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                height: 70,
                child: Card(
                  color: Colors.grey.withOpacity(.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: const [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Movie Search...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).textTheme.bodyLarge!.color,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.deepPurpleAccent,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Action'),
                Tab(text: 'Adventure'),
                Tab(text: 'Comedy'),
                Tab(text: 'Drama'),
                Tab(text: 'Family'),
                Tab(text: 'Horror'),
                Tab(text: 'Mystery'),
                Tab(text: 'Romance'),
                Tab(text: 'Sci-Fi'),
                Tab(text: 'War'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // All movies (You can use the existing ListView here if needed)
                  _buildGenreMoviesListView(actionFuture, 'Action Movies'),
                  _buildGenreMoviesListView(
                      adventureFuture, 'Adventure Movies'),
                  _buildGenreMoviesListView(comedyFuture, 'Comedy Movies'),
                  _buildGenreMoviesListView(dramaFuture, 'Drama Movies'),
                  _buildGenreMoviesListView(familyFuture, 'Family Movies'),
                  _buildGenreMoviesListView(horrorFuture, 'Horror Movies'),
                  _buildGenreMoviesListView(mysteryFuture, 'Mystery Movies'),
                  _buildGenreMoviesListView(romanceFuture, 'Romance Movies'),
                  _buildGenreMoviesListView(scifiFuture, 'Sci-Fi Movies'),
                  _buildGenreMoviesListView(warFuture, 'War Movies'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreMoviesListView(Future<Model> future, String headlineText) {
    return ListView(
      children: [
        MoviesListView(future: future, headlineText: headlineText),
      ],
    );
  }
}
