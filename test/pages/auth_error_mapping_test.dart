import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/pages/Login-Logout/auth_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<BuildContext> pumpContext(WidgetTester tester) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(Brightness.dark),
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(builder: (context) {
          captured = context;
          return const SizedBox.shrink();
        }),
      ),
    );
    return captured;
  }

  testWidgets('maps Firebase auth codes to localized copy', (tester) async {
    final context = await pumpContext(tester);
    final s = S.of(context);
    final expected = <String, String>{
      'invalid-credential': s.authErrorInvalidCredential,
      'wrong-password': s.authErrorInvalidCredential,
      'user-not-found': s.authErrorUserNotFound,
      'email-already-in-use': s.authErrorEmailInUse,
      'weak-password': s.authErrorWeakPassword,
      'invalid-email': s.authErrorInvalidEmail,
      'network-request-failed': s.authErrorNetwork,
      'too-many-requests': s.authErrorTooManyRequests,
      'requires-recent-login': s.authErrorRecentLogin,
      'something-unheard-of': s.authErrorGeneric,
    };
    expected.forEach((code, text) {
      expect(
        authErrorText(context, FirebaseAuthException(code: code)),
        text,
        reason: code,
      );
    });
  });

  testWidgets('hideAccountExistence maps user-not-found to invalid credential',
      (tester) async {
    final context = await pumpContext(tester);
    final s = S.of(context);
    final e = FirebaseAuthException(code: 'user-not-found');
    expect(
      authErrorText(context, e, hideAccountExistence: true),
      s.authErrorInvalidCredential,
    );
    expect(authErrorText(context, e), s.authErrorUserNotFound);
  });

  testWidgets('English copy matches the spec, with no raw exception text',
      (tester) async {
    final context = await pumpContext(tester);
    expect(
      authErrorText(context, FirebaseAuthException(code: 'invalid-credential')),
      'Email or password is incorrect.',
    );
    expect(
      authErrorText(
        context,
        FirebaseAuthException(code: 'network-request-failed', message: 'raw'),
      ),
      "You're offline. Check your connection and try again.",
    );
    expect(
      authErrorText(context, FirebaseAuthException(code: 'x', message: 'raw')),
      "Couldn't complete that. Try again.",
    );
  });
}
