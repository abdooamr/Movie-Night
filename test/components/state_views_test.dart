import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/sign_in_prompt.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(
      theme: buildAppTheme(Brightness.dark),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('Try Again calls onRetry once', (tester) async {
    var retries = 0;
    await tester.pumpWidget(_app(ErrorState(
      message: 'Something went wrong.',
      onRetry: () => retries++,
    )));
    expect(find.text('Something went wrong.'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
    await tester.tap(find.text('Try Again'));
    expect(retries, 1);
  });

  testWidgets('compact ErrorState uses a TextButton', (tester) async {
    var retries = 0;
    await tester.pumpWidget(_app(ErrorState(
      message: 'Could not load.',
      onRetry: () => retries++,
      compact: true,
    )));
    expect(find.byType(TextButton), findsOneWidget);
    await tester.tap(find.text('Try Again'));
    expect(retries, 1);
  });

  testWidgets('EmptyState shows title, body and action', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_app(EmptyState(
      icon: IconsaxOutline.video,
      title: 'Nothing Here',
      body: 'Add something.',
      actionLabel: 'Browse',
      onAction: () => taps++,
    )));
    expect(find.text('Nothing Here'), findsOneWidget);
    expect(find.text('Add something.'), findsOneWidget);
    await tester.tap(find.text('Browse'));
    expect(taps, 1);
  });

  testWidgets('SignInPrompt Log In calls onLogIn', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_app(SignInPrompt(onLogIn: () => taps++)));
    expect(find.byType(FilledButton), findsOneWidget);
    await tester.tap(find.text('Log In'));
    expect(taps, 1);
  });
}
