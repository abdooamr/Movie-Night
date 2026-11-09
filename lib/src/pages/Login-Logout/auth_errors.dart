import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../generated/l10n.dart';

/// Whether [e] is a wrong email or password.
///
/// Newer Auth servers send the `invalid_credentials` code; older ones only the
/// "Invalid login credentials" message with HTTP 400.
bool isInvalidCredentials(AuthException e) =>
    e.code == 'invalid_credentials' ||
    (e.code == null &&
        e.statusCode == '400' &&
        e.message.toLowerCase().contains('invalid login credentials'));

/// Maps a Supabase [AuthException] to localized, user-facing copy. Never
/// shows the raw exception message.
///
/// With [hideAccountExistence] (log-in forms), "user not found" reads as a
/// wrong email or password, so the form can't be used to probe for accounts.
String authErrorText(
  BuildContext context,
  AuthException e, {
  bool hideAccountExistence = false,
}) {
  final s = S.of(context);
  if (e is AuthRetryableFetchException) return s.authErrorNetwork;
  if (e is AuthWeakPasswordException) return s.authErrorWeakPassword;
  if (isInvalidCredentials(e)) return s.authErrorInvalidCredential;
  switch (e.code) {
    case 'user_not_found':
      return hideAccountExistence
          ? s.authErrorInvalidCredential
          : s.authErrorUserNotFound;
    case 'user_already_exists':
    case 'email_exists':
      return s.authErrorEmailInUse;
    case 'weak_password':
      return s.authErrorWeakPassword;
    case 'email_address_invalid':
    case 'validation_failed':
      return s.authErrorInvalidEmail;
    case 'email_not_confirmed':
      return s.authErrorEmailNotConfirmed;
    case 'same_password':
      return s.authErrorSamePassword;
    case 'over_request_rate_limit':
    case 'over_email_send_rate_limit':
      return s.authErrorTooManyRequests;
    case 'reauthentication_needed':
    case 'session_expired':
    case 'session_not_found':
      return s.authErrorRecentLogin;
    default:
      return s.authErrorGeneric;
  }
}
