import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/pages/Login-Logout/Forget_password.dart';
import 'package:Movie_Night/src/pages/Login-Logout/password_migration_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _app(Widget home) => MaterialApp(
      theme: buildAppTheme(Brightness.dark),
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: home,
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('claim is true once, then false', () async {
    expect(await PasswordMigrationNotice.claim(), isTrue);
    expect(await PasswordMigrationNotice.claim(), isFalse);
    expect(await PasswordMigrationNotice.claim(), isFalse);
  });

  test('claim stays false once recorded (survives restarts)', () async {
    SharedPreferences.setMockInitialValues(
        {PasswordMigrationNotice.prefsKey: true});
    expect(await PasswordMigrationNotice.claim(), isFalse);
  });

  testWidgets('Reset Password opens the reset screen with the email filled',
      (tester) async {
    await tester.pumpWidget(_app(Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () =>
              PasswordMigrationNotice.show(context, email: 'ada@example.com'),
          child: const Text('fail log-in'),
        ),
      ),
    )));
    await tester.tap(find.text('fail log-in'));
    await tester.pumpAndSettle();

    expect(find.text('Reset Your Password Once'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Reset Password'));
    await tester.pumpAndSettle();

    expect(find.byType(ForgetNew), findsOneWidget);
    expect(find.text('ada@example.com'), findsOneWidget);
  });

  testWidgets('Not Now just closes it', (tester) async {
    await tester.pumpWidget(_app(Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () => PasswordMigrationNotice.show(context),
          child: const Text('fail log-in'),
        ),
      ),
    )));
    await tester.tap(find.text('fail log-in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Not Now'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(ForgetNew), findsNothing);
  });
}
