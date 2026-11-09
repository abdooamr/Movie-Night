import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/pages/Login-Logout/auth_form_parts.dart';
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
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  testWidgets('AuthErrorText is a live region in the error colour',
      (tester) async {
    await tester.pumpWidget(_app(const AuthErrorText('Nope.')));
    final text = tester.widget<Text>(find.text('Nope.'));
    final scheme = Theme.of(tester.element(find.text('Nope.'))).colorScheme;
    expect(text.style?.color, scheme.error);
    expect(
      tester.getSemantics(find.text('Nope.')),
      matchesSemantics(label: 'Nope.', isLiveRegion: true),
    );
  });

  testWidgets('AuthSubmitButton shows the label and fires when idle',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(_app(AuthSubmitButton(
      label: 'Log In',
      busy: false,
      onPressed: () => taps++,
    )));
    expect(find.text('Log In'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.byType(FilledButton));
    expect(taps, 1);
  });

  testWidgets('AuthSubmitButton shows a spinner and is disabled when busy',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(_app(AuthSubmitButton(
      label: 'Log In',
      busy: true,
      onPressed: () => taps++,
    )));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Log In'), findsNothing);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
    await tester.tap(find.byType(FilledButton), warnIfMissed: false);
    expect(taps, 0);
  });

  group('closeSignInFlow', () {
    Widget page(String name, {VoidCallback? onTap, String? action}) => Scaffold(
          body: Column(children: [
            Text(name),
            if (onTap != null)
              TextButton(onPressed: onTap, child: Text(action!)),
          ]),
        );

    Route<void> route(Widget Function(BuildContext) b) =>
        MaterialPageRoute<void>(builder: b);

    /// Welcome -> Log In; Log In's button calls closeSignInFlow.
    Widget welcome(BuildContext context) => page('Welcome',
        action: 'Open Log In',
        onTap: () => Navigator.of(context).push(route((c) => page('Log In',
            action: 'Signed in', onTap: () => closeSignInFlow(c)))));

    testWidgets('inside a tab navigator it returns to the tab root',
        (tester) async {
      await tester.pumpWidget(_app(SizedBox(
        height: 400,
        width: 400,
        child: Navigator(
          onGenerateRoute: (_) => route(welcome),
        ),
      )));
      await tester.tap(find.text('Open Log In'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Signed in'));
      await tester.pumpAndSettle();

      expect(find.text('Log In'), findsNothing);
      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('as a sheet on the root navigator it closes the whole flow',
        (tester) async {
      await tester.pumpWidget(_app(Builder(
        builder: (context) => page('Home',
            action: 'Sign in',
            onTap: () => Navigator.of(context).push(route(welcome))),
      )));
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Log In'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Signed in'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Welcome'), findsNothing);
      expect(find.text('Log In'), findsNothing);
    });
  });
}
