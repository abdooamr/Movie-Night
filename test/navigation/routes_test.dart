import 'package:Movie_Night/src/components/poster_card.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_shell_harness.dart';

class _Rails extends StatelessWidget {
  const _Rails();

  @override
  Widget build(BuildContext context) {
    final trending = heroTagFor(source: 'trending', isTv: false, id: 1);
    final popular = heroTagFor(source: 'popular', isTv: false, id: 1);
    return Scaffold(
      body: Row(
        children: [
          for (final tag in [trending, popular])
            SizedBox(
              width: 120,
              child: PosterCard(
                posterPath: null,
                title: 'Dune $tag',
                heroTag: tag,
                onTap: () =>
                    openTitle(context, id: 1, isTv: false, heroTag: tag),
              ),
            ),
        ],
      ),
    );
  }
}

const _destKey = ValueKey('dest-hero');

void main() {
  final pushed = <(int, bool, String?)>[];

  setUp(() {
    pushed.clear();
    debugDetailPageBuilder = (id, isTv, heroTag) {
      pushed.add((id, isTv, heroTag));
      return Scaffold(
        body: Column(
          children: [
            Text('Detail $id'),
            Hero(
              tag: heroTag!,
              child: const SizedBox(key: _destKey, width: 300, height: 450),
            ),
          ],
        ),
      );
    };
  });
  tearDown(() => debugDetailPageBuilder = null);

  testWidgets('openTitle with a per-rail hero tag pushes on the tab navigator',
      (tester) async {
    await tester.pumpWidget(shellApp(
      isSignedIn: true,
      pagesBuilder: (_) => [
        const _Rails(),
        const SizedBox(),
        const SizedBox(),
        const SizedBox(),
      ],
    ));

    final trending = heroTagFor(source: 'trending', isTv: false, id: 1);
    final sourceWidth = tester.getSize(find.byType(Hero).first).width;
    await tester.tap(find.byType(PosterCard).first);
    await tester.pump(); // push
    await tester.pump(); // flight starts
    await tester.pump(MNDuration.short);
    // Mid-flight the shuttle (the destination child) sits between the two
    // sizes; without a HeroController on the tab navigator it would already
    // be its full 300 pt width.
    final midWidth = tester.getSize(find.byKey(_destKey)).width;
    expect(midWidth, greaterThan(sourceWidth + 1));
    expect(midWidth, lessThan(299));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(_destKey)).width, 300);

    expect(tester.takeException(), isNull);
    expect(find.text('Detail 1'), findsOneWidget);
    expect(pushed, [(1, false, trending)]);
    // Pushed inside the tab: the tab bar is still visible.
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
