import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/widgets/genreslistview.dart';
import 'package:flutter/material.dart';

/// "See All" page for one Home section: the section title and a poster grid.
class See_All extends StatelessWidget {
  const See_All({
    required this.future,
    super.key,
    required this.headlineText,
    required this.istvshow,
  });

  final String headlineText;
  final Future<Model> future;
  final bool istvshow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(headlineText)),
      body: GenresListView(
        future: future,
        headlineText: '',
        istvshow: istvshow,
      ),
    );
  }
}
