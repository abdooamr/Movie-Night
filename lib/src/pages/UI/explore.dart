import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/widgets/genreslistview.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/widgets/allwidget.dart';
import 'package:provider/provider.dart';

import '../../models/movie_model.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  late Future<Model> actionFuture,
      adventureFuture,
      animationFuture,
      comedyFuture,
      crimeFuture,
      documentaryFuture,
      dramaFuture,
      familyFuture,
      fantasyFuture,
      historyFuture,
      horrorFuture,
      mysteryFuture,
      romanceFuture,
      scifiFuture,
      thrillerFuture,
      warFuture;

  late TabController _tabController;
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    _tabController = TabController(length: 16, vsync: this);
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    actionFuture =
        discoverMovies(genreId: 28, lang: dropdownProvider.selectedValue);
    adventureFuture =
        discoverMovies(genreId: 12, lang: dropdownProvider.selectedValue);
    animationFuture =
        discoverMovies(genreId: 16, lang: dropdownProvider.selectedValue);
    comedyFuture =
        discoverMovies(genreId: 35, lang: dropdownProvider.selectedValue);
    crimeFuture =
        discoverMovies(genreId: 80, lang: dropdownProvider.selectedValue);
    documentaryFuture =
        discoverMovies(genreId: 99, lang: dropdownProvider.selectedValue);
    dramaFuture =
        discoverMovies(genreId: 18, lang: dropdownProvider.selectedValue);
    familyFuture =
        discoverMovies(genreId: 10751, lang: dropdownProvider.selectedValue);
    fantasyFuture =
        discoverMovies(genreId: 14, lang: dropdownProvider.selectedValue);
    historyFuture =
        discoverMovies(genreId: 36, lang: dropdownProvider.selectedValue);
    horrorFuture =
        discoverMovies(genreId: 27, lang: dropdownProvider.selectedValue);
    mysteryFuture =
        discoverMovies(genreId: 9648, lang: dropdownProvider.selectedValue);
    romanceFuture =
        discoverMovies(genreId: 10749, lang: dropdownProvider.selectedValue);
    scifiFuture =
        discoverMovies(genreId: 878, lang: dropdownProvider.selectedValue);
    thrillerFuture =
        discoverMovies(genreId: 53, lang: dropdownProvider.selectedValue);
    warFuture =
        discoverMovies(genreId: 10752, lang: dropdownProvider.selectedValue);

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
                  color: Colors.grey.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Text(S.of(context).searchhint),
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
              tabs: [
                Tab(text: S.of(context).Actiongenre),
                Tab(text: S.of(context).Adventuregenre),
                Tab(text: S.of(context).Animationgenre),
                Tab(text: S.of(context).Comedygenre),
                Tab(text: S.of(context).Crimegenre),
                Tab(text: S.of(context).Documentarygenre),
                Tab(text: S.of(context).Dramagenre),
                Tab(text: S.of(context).Familygenre),
                Tab(text: S.of(context).Fantasygenre),
                Tab(text: S.of(context).Historygenre),
                Tab(text: S.of(context).Horrorgenre),
                Tab(text: S.of(context).Mysterygenre),
                Tab(text: S.of(context).Romancegenre),
                Tab(text: S.of(context).ScienceFictiongenre),
                Tab(text: S.of(context).Thrillergenre),
                Tab(text: S.of(context).Wargenre),
              ],
            ),
            Consumer<DropdownProvider>(builder: (context, dropdownProvider, _) {
              return Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    GenresListView(
                      future: actionFuture,
                      headlineText: S.of(context).actionmovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: adventureFuture,
                      headlineText: S.of(context).adventuremovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: animationFuture,
                      headlineText: S.of(context).animationmovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: comedyFuture,
                      headlineText: S.of(context).comedymovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: crimeFuture,
                      headlineText: S.of(context).crimemovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: documentaryFuture,
                      headlineText: S.of(context).documentarymovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: dramaFuture,
                      headlineText: S.of(context).dramamovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: familyFuture,
                      headlineText: S.of(context).familymovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: fantasyFuture,
                      headlineText: S.of(context).fantasymovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: historyFuture,
                      headlineText: S.of(context).historymovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: horrorFuture,
                      headlineText: S.of(context).horrormovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: mysteryFuture,
                      headlineText: S.of(context).mysterymovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: romanceFuture,
                      headlineText: S.of(context).romancemovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: scifiFuture,
                      headlineText: S.of(context).sciencefictionmovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: thrillerFuture,
                      headlineText: S.of(context).thrillermovielabel,
                      istvshow: false,
                    ),
                    GenresListView(
                      future: warFuture,
                      headlineText: S.of(context).warmovielabel,
                      istvshow: false,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
