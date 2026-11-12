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

  testWidgets('no app bar title; room is kept for the Close button',
      (tester) async {
    await tester.pumpWidget(_app(const LoginWelcomeScreen()));
    expect(tester.widget<AppBar>(find.byType(AppBar)).title, isNull);
    final actions = tester.widget<AppBar>(find.byType(AppBar)).actions!;
    expect(actions.last, isA<SizedBox>());
  });
}
