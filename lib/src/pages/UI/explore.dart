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

/// Explore tabs in display order: TMDB genre id + localized label.
final List<(int, String Function(S))> _genreTabs = [
  (28, (s) => s.Actiongenre),
  (12, (s) => s.Adventuregenre),
  (16, (s) => s.Animationgenre),
  (35, (s) => s.Comedygenre),
  (80, (s) => s.Crimegenre),
  (99, (s) => s.Documentarygenre),
  (18, (s) => s.Dramagenre),
  (10751, (s) => s.Familygenre),
  (14, (s) => s.Fantasygenre),
  (36, (s) => s.Historygenre),
  (27, (s) => s.Horrorgenre),
  (9648, (s) => s.Mysterygenre),
  (10749, (s) => s.Romancegenre),
  (878, (s) => s.ScienceFictiongenre),
  (53, (s) => s.Thrillergenre),
  (10752, (s) => s.Wargenre),
];

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DropdownProvider dropdownProvider;

  /// Per-genre feeds, created on first view of a tab and reused afterwards so
  /// revisiting a tab or rebuilding does not refetch. Cleared when the
  /// language changes, since the cached results are localized.
  final Map<int, Future<Model>> _genreFutures = {};
  String? _genreFuturesLang;

  Future<Model> _futureFor(int genreId, String lang) {
    if (_genreFuturesLang != lang) {
      _genreFutures.clear();
      _genreFuturesLang = lang;
    }
    return _genreFutures.putIfAbsent(
        genreId, () => discoverMovies(genreId: genreId, lang: lang));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _genreTabs.length, vsync: this);
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  delegate: Search(lang: dropdownProvider.selectedValue),
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
              padding: EdgeInsets.zero,
              tabAlignment: TabAlignment.start,
              tabs: [
                for (final (_, label) in _genreTabs)
                  Tab(text: label(S.of(context))),
              ],
            ),
            Consumer<DropdownProvider>(builder: (context, dropdownProvider, _) {
              final lang = dropdownProvider.selectedValue;
              return Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Builder defers _futureFor until TabBarView actually
                    // builds the page, so only visited tabs hit the network.
                    for (final (genreId, _) in _genreTabs)
                      Builder(
                        builder: (context) => GenresListView(
                          future: _futureFor(genreId, lang),
                          headlineText: "",
                          istvshow: false,
                        ),
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
