import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/pages/Login-Logout/auth_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  AuthException code(String c, {String message = 'raw server text'}) =>
      AuthException(message, statusCode: '400', code: c);

  testWidgets('maps Supabase auth codes to localized copy', (tester) async {
    final context = await pumpContext(tester);
    final s = S.of(context);
    final expected = <String, String>{
      'invalid_credentials': s.authErrorInvalidCredential,
      'user_not_found': s.authErrorUserNotFound,
      'user_already_exists': s.authErrorEmailInUse,
      'email_exists': s.authErrorEmailInUse,
      'weak_password': s.authErrorWeakPassword,
      'email_address_invalid': s.authErrorInvalidEmail,
      'validation_failed': s.authErrorInvalidEmail,
      'email_not_confirmed': s.authErrorEmailNotConfirmed,
      'same_password': s.authErrorSamePassword,
      'over_request_rate_limit': s.authErrorTooManyRequests,
      'over_email_send_rate_limit': s.authErrorTooManyRequests,
      'reauthentication_needed': s.authErrorRecentLogin,
      'something_unheard_of': s.authErrorGeneric,
    };
    expected.forEach((c, text) {
      expect(authErrorText(context, code(c)), text, reason: c);
    });
  });

  testWidgets('network and weak-password exception types', (tester) async {
    final context = await pumpContext(tester);
    final s = S.of(context);
    expect(authErrorText(context, AuthRetryableFetchException(message: 'x')),
        s.authErrorNetwork);
    expect(
      authErrorText(
          context,
          AuthWeakPasswordException(
              message: 'x', statusCode: '422', reasons: const ['length'])),
      s.authErrorWeakPassword,
    );
  });

  test('isInvalidCredentials: by code, or by the old 400 message', () {
    expect(isInvalidCredentials(code('invalid_credentials')), isTrue);
    expect(
      isInvalidCredentials(const AuthException('Invalid login credentials',
          statusCode: '400')),
      isTrue,
    );
    expect(isInvalidCredentials(code('email_not_confirmed')), isFalse);
    expect(
        isInvalidCredentials(const AuthException('Invalid login credentials',
            statusCode: '500')),
        isFalse);
  });

  testWidgets('hideAccountExistence maps user_not_found to invalid credential',
      (tester) async {
    final context = await pumpContext(tester);
    final s = S.of(context);
    final e = code('user_not_found');
    expect(
      authErrorText(context, e, hideAccountExistence: true),
      s.authErrorInvalidCredential,
    );
    expect(authErrorText(context, e), s.authErrorUserNotFound);
  });

  testWidgets('English copy, with no raw exception text', (tester) async {
    final context = await pumpContext(tester);
    expect(authErrorText(context, code('invalid_credentials')),
        'Email or password is incorrect.');
    expect(authErrorText(context, code('email_not_confirmed')),
        'Confirm your email first. Open the link we sent you, then log in.');
    expect(authErrorText(context, code('x')),
        "Couldn't complete that. Try again.");
  });
}
