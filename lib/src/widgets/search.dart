import 'package:Movie_Night/generated/l10n.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/poster_card.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/navigation/routes.dart';
import 'package:Movie_Night/src/widgets/shimmerWidgets/searchResultShimmerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Movie_Night/src/pages/UI/castdetails.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import '../models/movie_model.dart';

class Search extends SearchDelegate<Model> {
  SharedPreferences? _prefs;
  final String lang;
  final Map<String, Future<Model>> _cache = {};

  static const _debounce = Duration(milliseconds: 300);
  static const _historyKey = 'search_queries';

  Search({required this.lang}) {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: S.of(context).clearSearchTooltip,
        onPressed: () {
          query = '';
        },
        icon: const Icon(IconsaxOutline.close_circle),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton(onPressed: () => close(context, Model(results: [])));
  }

  /// One future per query string: rebuilds reuse it, and a query the user has
  /// already typed past is dropped during the debounce without hitting TMDB.
  Future<Model> _search(String q) {
    return _cache.putIfAbsent(q, () async {
      await Future.delayed(_debounce);
      if (q != query) {
        _cache.remove(q);
        throw StateError('superseded');
      }
      try {
        return await searchData(q, lang);
      } catch (_) {
        _cache.remove(q); // allow retry on failure
        rethrow;
      }
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context, showSuggestions: true);
  }

  List<String> _history() => _prefs?.getStringList(_historyKey) ?? [];

  Widget _buildSearchResults(BuildContext context,
      {bool showSuggestions = false}) {
    if (_prefs == null) {
      return const searchResultShimmerWidget();
    }
    // StatefulBuilder so removing a history row or retrying a failed search
    // rebuilds this body without going through the delegate.
    return StatefulBuilder(
      builder: (context, setState) {
        if (query.isEmpty) {
          return _buildHistory(context, setState, showSuggestions);
        }
        return FutureBuilder<Model>(
          future: _search(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                (snapshot.error is StateError)) {
              return const searchResultShimmerWidget();
            }
            if (snapshot.hasError) {
              return ErrorState(
                message: S.of(context).noDataFound,
                onRetry: () {
                  _cache.remove(query);
                  setState(() {});
                },
              );
            }
            final data = snapshot.data!.results;
            if (data.isEmpty) {
              return EmptyState(
                icon: IconsaxOutline.search_normal,
                title: S.of(context).noResultsFor(query),
              );
            }
            return _buildResultList(context, data);
          },
        );
      },
    );
  }

  Widget _buildResultList(BuildContext context, List<Result> data) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: EdgeInsetsDirectional.only(bottom: _bottomClearance(context)),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        final isPerson = item.mediaType == MediaType.person;
        final isTv = item.mediaType == MediaType.tv;
        final title = item.title ?? item.name ?? '';
        final subtitle = _subtitle(context, item);
        final path = isPerson ? item.profilePath : item.posterPath;
        return Semantics(
          button: true,
          label: subtitle == null ? title : '$title, $subtitle',
          excludeSemantics: true,
          child: ListTile(
            minVerticalPadding: MNSpace.sm,
            onTap: () {
              if (isPerson) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Cast_DetailPage(id: item.id),
                  ),
                );
              } else {
                openTitle(
                  context,
                  id: item.id!,
                  isTv: isTv,
                  heroTag: heroTagFor(source: 'search', isTv: isTv, id: item.id!),
                );
              }
            },
            leading: SizedBox(
              width: 40,
              height: 60,
              child: path == null
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius: MNRadius.smAll,
                      ),
                      child: Icon(
                        isPerson ? IconsaxOutline.user : IconsaxOutline.video,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : CachedImageCustom(
                      '$imageUrl$path',
                      width: 40,
                      height: 60,
                      borderRadius: MNRadius.smAll,
                      isPerson: isPerson,
                    ),
            ),
            title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: subtitle == null
                ? null
                : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        );
      },
    );
  }

  /// "Movie · 2023".
  String? _subtitle(BuildContext context, Result item) {
    if (item.mediaType == MediaType.person) return null;
    final s = S.of(context);
    final kind = item.mediaType == MediaType.tv ? s.mediaTvShow : s.mediaMovie;
    final date = item.releaseDate ?? item.firstAirDate ?? '';
    final year = date.length >= 4 ? date.substring(0, 4) : '';
    return year.isEmpty ? kind : '$kind · $year';
  }

  Widget _buildHistory(
      BuildContext context, StateSetter setState, bool showSuggestions) {
    final saved = _history();
    if (!showSuggestions || saved.isEmpty) return const SizedBox.shrink();
    void remove(String q) {
      final list = _history()..remove(q);
      _prefs!.setStringList(_historyKey, list);
      setState(() {});
    }

    return ListView.builder(
      padding: EdgeInsetsDirectional.only(bottom: _bottomClearance(context)),
      itemCount: saved.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: MNSpace.sm),
              child: TextButton(
                onPressed: () {
                  _prefs!.setStringList(_historyKey, []);
                  setState(() {});
                },
                child: Text(S.of(context).clearHistory),
              ),
            ),
          );
        }
        final q = saved[index - 1];
        return Dismissible(
          key: ValueKey('history-$q'),
          onDismissed: (_) => remove(q),
          child: ListTile(
            onTap: () {
              // Populate the search bar with the saved query and trigger a search
              query = q;
              showResults(context);
            },
            leading: const Icon(IconsaxOutline.clock),
            title: Text(q),
            trailing: IconButton(
              tooltip: S.of(context).removeFromHistory,
              icon: const Icon(IconsaxOutline.close_circle),
              onPressed: () => remove(q),
            ),
          ),
        );
      },
    );
  }

  double _bottomClearance(BuildContext context) =>
      MNSize.minTap + MNSpace.lg * 2 + MediaQuery.paddingOf(context).bottom;

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    // Save the search query to SharedPreferences
    if (_prefs != null && query.isNotEmpty) {
      final savedQueries = _history();
      if (!savedQueries.contains(query)) {
        savedQueries.insert(0, query);
        _prefs!.setStringList(_historyKey, savedQueries);
      }
    }
  }
}
