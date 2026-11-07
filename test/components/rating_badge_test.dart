import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/rating_badge.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child, {Brightness brightness = Brightness.dark}) =>
    MaterialApp(
      theme: buildAppTheme(brightness),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  testWidgets('accessible label is "7.3 out of 10"', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app(const RatingBadge(score: 7.3)));
    expect(find.bySemanticsLabel('7.3 out of 10'), findsOneWidget);
    expect(find.text('7.3'), findsOneWidget);
    expect(find.text('TMDB'), findsNothing);
    handle.dispose();
  });

  testWidgets('optional TMDB caption', (tester) async {
    await tester
        .pumpWidget(_app(const RatingBadge(score: 7.3, showSource: true)));
    expect(find.text('TMDB'), findsOneWidget);
  });

  for (final b in Brightness.values) {
    testWidgets('text contrast on $b', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_app(
          const RatingBadge(score: 7.3, showSource: true),
          brightness: b));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  }
}
