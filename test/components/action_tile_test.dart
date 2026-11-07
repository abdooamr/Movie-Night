import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Movie_Night/src/components/action_tile.dart';

import '_harness.dart';

void main() {
  testWidgets('selected tile exposes toggled semantics and taps',
      (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(harness(ActionTile(
      icon: Icons.favorite_border,
      selectedIcon: Icons.favorite,
      label: 'Like',
      selected: true,
      onTap: () => taps++,
    )));
    final node = tester.getSemantics(find.byType(ActionTile));
    final flags = node.getSemanticsData().flagsCollection;
    expect(flags.hasToggledState, isTrue);
    expect(flags.isToggled, isTrue);
    expect(flags.isButton, isTrue);
    expect(node.label, 'Like');
    await tester.tap(find.byType(ActionTile));
    expect(taps, 1);
    final size = tester.getSize(find.byType(ActionTile));
    expect(size.width, greaterThanOrEqualTo(72));
    expect(size.height, greaterThanOrEqualTo(72));
    handle.dispose();
  });

  testWidgets('meets tap target guideline', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(harness(ActionTile(
      icon: Icons.add,
      label: 'Watchlist',
      onTap: () {},
    )));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    handle.dispose();
  });
}
