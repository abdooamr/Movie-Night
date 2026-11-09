import 'dart:async';

import 'package:Movie_Night/src/design/performance.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/widgets/upcoming.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../components/_harness.dart';

Model _model(int count) => Model(results: [
      for (var i = 0; i < count; i++)
        Result(
          id: i,
          title: 'Hero $i',
          posterPath: null,
          genreIds: const [],
          mediaType: MediaType.movie,
        ),
    ]);

Widget _hero(Future<Model> future, ValueChanged<Result> onFocus) => harness(
      SingleChildScrollView(
        child: UpcomingMovies(
          future: future,
          headlineText: 'Upcoming',
          istvshow: false,
          onRetry: () {},
          onFocusChanged: onFocus,
        ),
      ),
    );

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
}

void main() {
  testWidgets('refresh keeps the carousel page and dot index', (tester) async {
    final focused = <int>[];
    await tester
        .pumpWidget(_hero(Future.value(_model(10)), (r) => focused.add(r.id!)));
    await _settle(tester);

    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1500);
    await _settle(tester);
    final page = focused.last;
    expect(page, isNot(0), reason: 'the swipe must leave the first page');

    // Refresh: a pending future first, then the new data.
    final next = Completer<Model>();
    await tester.pumpWidget(_hero(next.future, (r) => focused.add(r.id!)));
    await tester.pump();
    expect(find.byType(PageView), findsOneWidget);

    next.complete(_model(10));
    await _settle(tester);
    expect(focused.last, page);
    expect(find.byType(PageView), findsOneWidget);
  });

  testWidgets('refresh error keeps the carousel and shows retry',
      (tester) async {
    await tester.pumpWidget(_hero(Future.value(_model(10)), (_) {}));
    await _settle(tester);

    await tester.pumpWidget(_hero(
      Future<Model>.error(Exception('offline'))..ignore(),
      (_) {},
    ));
    await _settle(tester);

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('low power turns off carousel enlarge', (tester) async {
    Future<bool> enlargeWith({required bool lowPower}) async {
      final monitor = PerformanceMonitor(debugForceLowPower: lowPower);
      addTearDown(monitor.dispose);
      await tester.pumpWidget(PerformanceScope(
        notifier: monitor,
        child: _hero(Future.value(_model(10)), (_) {}),
      ));
      await _settle(tester);
      return tester
          .widget<CarouselSlider>(find.byType(CarouselSlider))
          .options
          .enlargeCenterPage!;
    }

    expect(await enlargeWith(lowPower: false), isTrue);
    expect(await enlargeWith(lowPower: true), isFalse);
  });
}
