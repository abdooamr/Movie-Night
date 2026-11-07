import 'package:Movie_Night/src/components/poster_card.dart';
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

void main() {
  final pushed = <(int, bool, String?)>[];

  setUp(() {
    pushed.clear();
    debugDetailPageBuilder = (id, isTv, heroTag) {
      pushed.add((id, isTv, heroTag));
      return Scaffold(body: Center(child: Text('Detail $id')));
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
    await tester.tap(find.byType(PosterCard).first);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Detail 1'), findsOneWidget);
    expect(pushed, [(1, false, trending)]);
    // Pushed inside the tab: the tab bar is still visible.
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
