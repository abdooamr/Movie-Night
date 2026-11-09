import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/widgets/explore_search_header.dart';
import 'package:Movie_Night/src/widgets/genreslistview.dart';
import 'package:Movie_Night/src/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:provider/provider.dart';

import '../../models/movie_model.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

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

  /// Absorbs the pinned header's height so each genre grid starts below it.
  final SliverOverlapAbsorberHandle _overlapHandle =
      SliverOverlapAbsorberHandle();

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

  void _openSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: Search(lang: dropdownProvider.selectedValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: _overlapHandle,
            // No title row: the search field sits right under the status
            // bar, the genre tabs under it. The header carries the page name
            // for assistive tech.
            sliver: SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              forceElevated: innerBoxIsScrolled,
              toolbarHeight: 0,
              bottom: ExploreSearchHeader(
                title: s.explorenavbar,
                hint: s.searchhint,
                tabs: [for (final (_, label) in _genreTabs) label(s)],
                controller: _tabController,
                onSearch: () => _openSearch(context),
                textScaler: MediaQuery.textScalerOf(context),
              ),
            ),
          ),
        ],
        body: Consumer<DropdownProvider>(
          builder: (context, dropdownProvider, _) {
            final lang = dropdownProvider.selectedValue;
            return TabBarView(
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
                      genreId: genreId,
                      overlapHandle: _overlapHandle,
                      onRetry: () =>
                          setState(() => _genreFutures.remove(genreId)),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
