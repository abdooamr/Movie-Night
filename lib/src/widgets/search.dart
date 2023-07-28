import 'package:Movie_Night/src/pages/UI/castdetails.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/pages/UI/detail_page.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import '../models/movie_model.dart';
import 'package:query/query.dart';

class Search extends SearchDelegate<Model> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
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
                    return;
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
                              id: data[index].id),
                        ));
                  }
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    data[index].posterPath == null
                        ? imageUrl + data[index].posterPath!
                        : imageUrl + data[index].profilePath!,
                  ),
                ),
                title: Text(data[index].title ?? data[index].name!),
              );
            },
          );
        } else if (query.isEmpty) {
          return const SizedBox();
        } else {
          return const Center(
            child: Text('Not Found'),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
                        ));
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
                              id: data[index].id),
                        ));
                  }
                },
                leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      data[index].posterPath == null
                          ? '$imageUrl${data[index].profilePath}'
                          : '$imageUrl${data[index].posterPath}',
                    )),
                title: Text(data[index].title ?? data[index].name!),
              );
            },
          );
        } else if (query.isEmpty) {
          return const SizedBox();
        } else {
          return const Center(
            child: Text('Not Found'),
          );
        }
      },
    );
  }
}
