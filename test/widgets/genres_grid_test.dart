import 'package:Movie_Night/src/components/poster_card.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/widgets/genreslistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../components/_harness.dart';

Model _model(int n) => Model(results: [
      for (var i = 0; i < n; i++)
        Result(id: i + 1, title: 'Title $i', genreIds: const [28]),
    ]);

Future<void> _pump(WidgetTester tester, Size size, Future<Model> future,
    {VoidCallback? onRetry}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(harness(GenresListView(
    future: future,
    headlineText: '',
    istvshow: false,
    genreId: 28,
    onRetry: onRetry,
  )));
  await tester.pump();
  await tester.pump();
}

/// Number of distinct x positions among the visible cards.
int _columns(WidgetTester tester) {
  final xs = <int>{};
  for (final e in find.byType(PosterCard).evaluate()) {
    xs.add(tester.getTopLeft(find.byWidget(e.widget)).dx.round());
  }
  return xs.length;
}

void main() {
  testWidgets('2 columns at 390 wide', (tester) async {
    await _pump(tester, const Size(390, 844), Future.value(_model(6)));
    expect(find.byType(PosterCard), findsWidgets);
    expect(_columns(tester), 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('at least 4 columns at 834 wide', (tester) async {
    await _pump(tester, const Size(834, 1112), Future.value(_model(8)));
    expect(_columns(tester), greaterThanOrEqualTo(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a failed future shows ErrorState and retries', (tester) async {
    var retries = 0;
    final failing = Future<Model>.error(Exception('boom'))..ignore();
    await _pump(tester, const Size(390, 844), failing,
        onRetry: () => retries++);
    expect(find.byType(ErrorState), findsOneWidget);
    await tester.tap(find.text('Try Again'));
    expect(retries, 1);
  });
}
