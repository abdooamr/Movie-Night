import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/design/performance.dart';
import 'package:Movie_Night/src/pages/Login-Logout/Login_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

Widget _app(Widget child, {bool lowPower = false}) {
  final monitor = PerformanceMonitor(debugForceLowPower: lowPower);
  return PerformanceScope(
    notifier: monitor,
    child: MaterialApp(
      theme: buildAppTheme(Brightness.dark),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: child,
    ),
  );
}

bool _animates(WidgetTester tester) =>
    tester.widget<LottieBuilder>(find.byType(LottieBuilder)).animate ?? true;

void main() {
  testWidgets('the Lottie loops normally and stops in low power',
      (tester) async {
    await tester.pumpWidget(_app(const LoginWelcomeScreen()));
    expect(_animates(tester), isTrue);

    await tester.pumpWidget(
        _app(const LoginWelcomeScreen(), lowPower: true));
    expect(_animates(tester), isFalse);
  });

  testWidgets('inline title is announced as a heading', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
        _app(const LoginWelcomeScreen(inSheet: false, title: 'Profile')));
    expect(
      tester.getSemantics(find.text('Profile')),
      containsSemantics(label: 'Profile', isHeader: true),
    );
    handle.dispose();
  });

  testWidgets('the sheet has no title', (tester) async {
    await tester.pumpWidget(_app(const LoginWelcomeScreen()));
    expect(find.text('Profile'), findsNothing);
  });
}
