import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/section_header.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child, {TextDirection dir = TextDirection.ltr}) =>
    MaterialApp(
      theme: buildAppTheme(Brightness.dark),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Directionality(
        textDirection: dir,
        child: Scaffold(body: child),
      ),
    );

final _seeAll = find.byWidgetPredicate((w) => w is TextButton);

void main() {
  testWidgets('title is a header', (tester) async {
    final handle = tester.ensureSemantics();
    await tester
        .pumpWidget(_app(SectionHeader(title: 'Trending', onSeeAll: () {})));
    final node = tester.getSemantics(find.text('Trending'));
    expect(node.flagsCollection.isHeader, isTrue);
    handle.dispose();
  });

  testWidgets('See All calls onSeeAll; hidden without callback',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(
        _app(SectionHeader(title: 'Trending', onSeeAll: () => taps++)));
    await tester.tap(_seeAll);
    expect(taps, 1);
    await tester.pumpWidget(_app(const SectionHeader(title: 'Trending')));
    expect(_seeAll, findsNothing);
  });

  testWidgets('See All sits at the start edge in RTL', (tester) async {
    await tester.pumpWidget(_app(
      SectionHeader(title: 'Trending', onSeeAll: () {}),
      dir: TextDirection.rtl,
    ));
    expect(tester.getTopLeft(_seeAll).dx, lessThan(100));
  });

  testWidgets('See All sits at the end edge in LTR', (tester) async {
    await tester
        .pumpWidget(_app(SectionHeader(title: 'Trending', onSeeAll: () {})));
    expect(tester.getTopRight(_seeAll).dx, greaterThan(700));
  });
}
