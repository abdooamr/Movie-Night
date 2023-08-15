import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/widgets/genreslistview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class See_All extends StatelessWidget {
  const See_All({
    required this.future,
    Key? key,
    required this.headlineText,
  }) : super(key: key);
  final String headlineText;
  final Future<Model> future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(headlineText),
        ),
        body:
            Consumer<DropdownProvider>(builder: (context, dropdownProvider, _) {
          return GenresListView(
            future: future,
            headlineText: headlineText,
          );
        }));
  }
}
