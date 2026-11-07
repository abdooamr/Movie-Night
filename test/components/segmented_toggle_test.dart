import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Movie_Night/src/components/segmented_toggle.dart';

import '_harness.dart';

Widget _toggle(void Function(int) onChanged, {TextDirection? dir}) => harness(
      SegmentedToggle<int>(
        segments: const [(1, 'Movies'), (2, 'TV Shows')],
        selected: 1,
        onChanged: onChanged,
      ),
      dir: dir,
    );

List<String> _selectedLabels(WidgetTester tester) => [
      for (final sem in tester.widgetList<Semantics>(find.byType(Semantics)))
        if (sem.properties.selected == true)
          ...tester
              .widgetList<Text>(find.descendant(
                  of: find.byWidget(sem), matching: find.byType(Text)))
              .map((t) => t.data ?? ''),
    ];

void main() {
  testWidgets('tapping second segment calls onChanged', (tester) async {
    int? got;
    await tester.pumpWidget(_toggle((v) => got = v));
    await tester.tap(find.text('TV Shows'));
    await tester.pump();
    expect(got, 2);
  });

  testWidgets('iOS uses CupertinoSlidingSegmentedControl', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await tester.pumpWidget(_toggle((_) {}));
      expect(
          find.byType(CupertinoSlidingSegmentedControl<int>), findsOneWidget);
      expect(find.byType(SegmentedButton<int>), findsNothing);
      expect(_selectedLabels(tester), contains('Movies'));
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('material selected segment exposes selected semantics',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_toggle((_) {}));
    expect(_selectedLabels(tester), contains('Movies'));
    expect(_selectedLabels(tester), isNot(contains('TV Shows')));
    handle.dispose();
  });

  testWidgets('RTL puts first segment right of second', (tester) async {
    await tester.pumpWidget(_toggle((_) {}, dir: TextDirection.rtl));
    expect(tester.getCenter(find.text('Movies')).dx,
        greaterThan(tester.getCenter(find.text('TV Shows')).dx));
  });

  testWidgets('meets android tap target guideline', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_toggle((_) {}));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    handle.dispose();
  });
}
