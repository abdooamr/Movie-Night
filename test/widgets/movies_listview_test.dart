import 'dart:async';

import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/widgets/movies_listview.dart';
import 'package:Movie_Night/src/widgets/shimmerWidgets/movieListViewShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../components/_harness.dart';

Widget _rail(Future<Model> future,
        {double textScale = 1, VoidCallback? onRetry}) =>
    harness(
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: SingleChildScrollView(
            child: MoviesListView(
              future: future,
              headlineText: 'Trending',
              istvshow: false,
              onRetry: onRetry,
            ),
          ),
        ),
      ),
    );

Model _model(int count) => Model(results: [
      for (var i = 0; i < count; i++)
        Result(
          id: i,
          title: 'Film $i',
          posterPath: null,
          genreIds: const [],
          mediaType: MediaType.movie,
        ),
    ]);

void main() {
  testWidgets('error shows Try Again and calls onRetry', (tester) async {
    var retries = 0;
    await tester.pumpWidget(_rail(
      // ignore(): the error is consumed by the FutureBuilder, not unhandled.
      Future<Model>.error(Exception('offline'))..ignore(),
      onRetry: () => retries++,
    ));
    await tester.pump();
    await tester.pump();

    expect(find.text('Try Again'), findsOneWidget);
    await tester.tap(find.text('Try Again'));
    await tester.pump();
    expect(retries, 1);
  });

  testWidgets('horizontal rail at default text size', (tester) async {
    await tester.pumpWidget(_rail(Future.value(_model(8))));
    await tester.pump();
    await tester.pump();

    final list = tester.widget<ListView>(find.byType(ListView));
    expect(list.scrollDirection, Axis.horizontal);
    expect(find.text('Film 0'), findsOneWidget);
  });

  testWidgets('stacks vertically at text scale 1.6, first 6 items',
      (tester) async {
    await tester.pumpWidget(_rail(Future.value(_model(10)), textScale: 1.6));
    await tester.pump();
    await tester.pump();

    final list = tester.widget<ListView>(find.byType(ListView));
    expect(list.scrollDirection, Axis.vertical);
    expect(find.text('Film 5'), findsOneWidget);
    expect(find.text('Film 6'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('refresh keeps the old rail visible', (tester) async {
    await tester.pumpWidget(_rail(Future.value(_model(5))));
    await tester.pump();
    await tester.pump();
    expect(find.text('Film 0'), findsOneWidget);

    // A refresh swaps in a pending future: the old posters stay.
    await tester.pumpWidget(_rail(Completer<Model>().future));
    await tester.pump();

    expect(find.text('Film 0'), findsOneWidget);
    expect(find.byType(movieListViewShimmerWidget), findsNothing);
  });

  testWidgets('refresh error keeps the old rail and shows retry',
      (tester) async {
    var retries = 0;
    await tester
        .pumpWidget(_rail(Future.value(_model(5)), onRetry: () => retries++));
    await tester.pump();
    await tester.pump();

    await tester.pumpWidget(_rail(
      Future<Model>.error(Exception('offline'))..ignore(),
      onRetry: () => retries++,
    ));
    await tester.pump();
    await tester.pump();

    expect(find.text('Film 0'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
    await tester.tap(find.text('Try Again'));
    expect(retries, 1);
  });
}
