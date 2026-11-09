import 'dart:async';

import 'package:Movie_Night/src/components/action_tile.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/widgets/addtowatchlist.dart';
import 'package:flutter_test/flutter_test.dart';

import '../components/_harness.dart';

/// Initial read controlled by the test; writes succeed.
class _FakeRepo extends UserRepository {
  final initialRead = Completer<bool>();
  final added = <int>[];

  @override
  Future<bool> isInWatchlist(int id, {required bool isTvShow}) =>
      initialRead.future;

  @override
  Future<void> addToWatchlist(int id, {required bool isTvShow}) async =>
      added.add(id);

  @override
  Future<void> removeFromWatchlist(int id, {required bool isTvShow}) async {}
}

bool _selected(WidgetTester t) =>
    t.widget<ActionTile>(find.byType(ActionTile)).selected;

/// Created inside each test body: a Completer made in setUp lives outside
/// the test's fake-async zone, and its result would only arrive after the
/// test's checks.
_FakeRepo _install() {
  final repo = _FakeRepo();
  UserRepository.instance = repo;
  return repo;
}

void main() {
  testWidgets('a late initial read does not undo the tap', (tester) async {
    final repo = _install();
    await tester.pumpWidget(
        harness(const Watchlistwidget(movieid: 603, istvshow: false)));
    expect(_selected(tester), isFalse);

    await tester.tap(find.byType(ActionTile));
    await tester.pump();
    expect(_selected(tester), isTrue);
    expect(repo.added, [603]);

    // The read started before the tap finishes now, with the old value.
    repo.initialRead.complete(false);
    await tester.pumpAndSettle();
    expect(_selected(tester), isTrue);
  });

  testWidgets('the initial read sets the state when nothing was tapped',
      (tester) async {
    final repo = _install();
    await tester.pumpWidget(
        harness(const Watchlistwidget(movieid: 603, istvshow: false)));
    repo.initialRead.complete(true);
    await tester.pumpAndSettle();
    expect(_selected(tester), isTrue);
  });
}
