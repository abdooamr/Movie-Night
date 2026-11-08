import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../../../generated/l10n.dart';

/// Maps a [FirebaseAuthException] to localized, user-facing copy. Never shows
/// the raw exception message.
///
/// With [hideAccountExistence] (log-in forms), `user-not-found` reads as a
/// wrong email or password, so the form can't be used to probe for accounts.
String authErrorText(
  BuildContext context,
  FirebaseAuthException e, {
  bool hideAccountExistence = false,
}) {
  final s = S.of(context);
  switch (e.code) {
    case 'invalid-credential':
    case 'wrong-password':
      return s.authErrorInvalidCredential;
    case 'user-not-found':
      return hideAccountExistence
          ? s.authErrorInvalidCredential
          : s.authErrorUserNotFound;
    case 'email-already-in-use':
      return s.authErrorEmailInUse;
    case 'weak-password':
      return s.authErrorWeakPassword;
    case 'invalid-email':
      return s.authErrorInvalidEmail;
    case 'network-request-failed':
      return s.authErrorNetwork;
    case 'too-many-requests':
      return s.authErrorTooManyRequests;
    case 'requires-recent-login':
      return s.authErrorRecentLogin;
    default:
      return s.authErrorGeneric;
  }
}
