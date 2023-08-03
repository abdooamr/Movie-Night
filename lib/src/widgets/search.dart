import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Movie_Night/src/pages/UI/castdetails.dart';
import 'package:Movie_Night/src/pages/UI/detail_page.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import '../models/movie_model.dart';

class Search extends SearchDelegate<Model> {
  SharedPreferences? _prefs;

  Search() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context, showSuggestions: true);
  }

  Widget _buildSearchResults(BuildContext context,
      {bool showSuggestions = false}) {
    if (_prefs == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final savedQueries = _prefs!.getStringList('search_queries') ?? [];

    return FutureBuilder<Model>(
      future: searchData(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData && query.isNotEmpty) {
          final data = snapshot.data?.results;
          return ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  if (data[index].mediaType == MediaType.person) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Cast_DetailPage(id: data[index].id),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          data: snapshot.data!,
                          index: index,
                          isTvShow: data[index].mediaType == MediaType.movie
                              ? false
                              : true,
                          id: data[index].id,
                        ),
                      ),
                    );
                  }
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    data[index].posterPath == null &&
                            data[index].profilePath == null
                        ? 'https://www.allianceplast.com/wp-content/uploads/2017/11/no-image.png'
                        : data[index].posterPath == null
                            ? '$imageUrl${data[index].profilePath}'
                            : '$imageUrl${data[index].posterPath}',
                  ),
                ),
                title: Text(data[index].title ?? data[index].name!),
              );
            },
          );
        } else if (query.isEmpty) {
          if (showSuggestions && savedQueries.isNotEmpty) {
            return ListView.builder(
              itemCount: savedQueries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    // Populate the search bar with the saved query and trigger a search
                    query = savedQueries[index];
                    showSuggestions = false;
                    showResults(context);
                  },
                  leading: Icon(Icons.history),
                  title: Text(savedQueries[index]),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const Center(
            child: Text('Not Found'),
          );
        }
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    // Save the search query to SharedPreferences
    if (_prefs != null && query.isNotEmpty) {
      final savedQueries = _prefs!.getStringList('search_queries') ?? [];
      if (!savedQueries.contains(query)) {
        savedQueries.insert(0, query);
        _prefs!.setStringList('search_queries', savedQueries);
      }
    }
  }
}
