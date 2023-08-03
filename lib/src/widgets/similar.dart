import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/widgets/movies_listview.dart';
import '../models/movie_model.dart';

class SimilarWidget extends StatefulWidget {
  const SimilarWidget({Key? key, required this.id, required this.isTvShow})
      : super(key: key);
  final int id;

  final bool isTvShow;
  @override
  State<SimilarWidget> createState() => _SimilarWidgetState();
}

class _SimilarWidgetState extends State<SimilarWidget> {
  late Future<Model> _future;
  @override
  void initState() {
    _future = getrecommendations(widget.id, widget.isTvShow);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MoviesListView(
      future: _future,
      headlineText: 'Recommendation',
    );
  }
}
