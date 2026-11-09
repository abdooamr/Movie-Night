import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Movie_Night/src/components/action_tile.dart';
import 'package:Movie_Night/src/widgets/detail_actions.dart';

import '../components/_harness.dart';

class _Calls {
  int signIn = 0;
  int like = 0;
  int trailers = 0;
  int imdb = 0;
  int share = 0;
}

Widget _actions(_Calls c, {required bool loggedIn, Widget? watchlist}) {
  return harness(SizedBox(
    width: 360,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DetailMoreMenu(onShare: () => c.share++, onOpenImdb: () => c.imdb++),
        DetailActions(
          isLoggedIn: loggedIn,
          isLiked: false,
          onToggleLike: () => c.like++,
          onRequireSignIn: () => c.signIn++,
          onWatchTrailers: () => c.trailers++,
          onShare: () => c.share++,
          watchlist: watchlist,
        ),
      ],
    ),
  ));
}

void main() {
  testWidgets('signed out: Like and Share work; Watchlist asks to sign in',
      (tester) async {
    final c = _Calls();
    await tester.pumpWidget(_actions(c, loggedIn: false));

    // Likes are stored on the device: no account needed.
    await tester.tap(find.widgetWithText(ActionTile, 'Like'));
    expect(c.like, 1);
    expect(c.signIn, 0);

    await tester.tap(find.widgetWithText(ActionTile, 'Add to Watchlist'));
    expect(c.signIn, 1);

    await tester.tap(find.widgetWithText(ActionTile, 'Share'));
    expect(c.share, 1);
    expect(c.signIn, 1);
  });

  testWidgets('signed in: Like toggles and the watchlist slot is shown',
      (tester) async {
    final c = _Calls();
    await tester.pumpWidget(_actions(
      c,
      loggedIn: true,
      watchlist: const Text('watchlist-slot'),
    ));

    await tester.tap(find.widgetWithText(ActionTile, 'Like'));
    expect(c.like, 1);
    expect(c.signIn, 0);
    expect(find.text('watchlist-slot'), findsOneWidget);
    expect(find.text('Add to Watchlist'), findsNothing);
  });

  testWidgets('Watch Trailers is the single filled button', (tester) async {
    final c = _Calls();
    await tester.pumpWidget(_actions(c, loggedIn: false));
    expect(find.byWidgetPredicate((w) => w is FilledButton), findsOneWidget);
    await tester.tap(find.text('Watch Trailers'));
    expect(c.trailers, 1);
  });

  testWidgets('three tiles: Like, Watchlist, Share; IMDb is not a tile',
      (tester) async {
    await tester.pumpWidget(_actions(_Calls(), loggedIn: false));
    expect(find.byType(ActionTile), findsNWidgets(3));
    expect(find.widgetWithText(ActionTile, 'IMDb'), findsNothing);
  });

  testWidgets('the ⋯ menu offers Share and Open in IMDb', (tester) async {
    final c = _Calls();
    await tester.pumpWidget(_actions(c, loggedIn: false));
    await tester.tap(find.byType(DetailMoreMenu));
    await tester.pumpAndSettle();
    expect(find.text('Open in IMDb'), findsOneWidget);
    await tester.tap(find.text('Open in IMDb'));
    await tester.pumpAndSettle();
    expect(c.imdb, 1);

    await tester.tap(find.byType(DetailMoreMenu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share').last);
    await tester.pumpAndSettle();
    expect(c.share, 1);
  });

  testWidgets('without an IMDb id the menu has only Share', (tester) async {
    await tester.pumpWidget(harness(DetailMoreMenu(onShare: () {})));
    await tester.tap(find.byType(DetailMoreMenu));
    await tester.pumpAndSettle();
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Open in IMDb'), findsNothing);
  });

  testWidgets('every action meets the tap target and label guidelines',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_actions(_Calls(), loggedIn: false));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    handle.dispose();
  });
}
