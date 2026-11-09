import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/app_logger.dart';
import 'supabase_config.dart';

/// Outcome of [AuthRepository.signInWithGoogle]: a dismissed account picker
/// is not an error.
enum GoogleSignInResult { success, cancelled, failed }

/// Outcome of [AuthRepository.signUp]. With "Confirm email" on, Supabase
/// creates the account without a session until the link is opened.
enum SignUpOutcome { signedIn, confirmEmail }

/// Every Supabase Auth call the app makes. The profile row is created by a
/// database trigger from the sign-up metadata, never by the app.
class AuthRepository {
  AuthRepository({SupabaseClient? client, GoogleSignIn? google})
      : _clientOverride = client,
        _googleOverride = google;

  static AuthRepository? _instance;
  static AuthRepository get instance => _instance ??= AuthRepository();

  @visibleForTesting
  static set instance(AuthRepository repo) => _instance = repo;

  // Resolved lazily so constructing the repository never touches Supabase
  // before `Supabase.initialize()` (and widget tests never touch it at all).
  final SupabaseClient? _clientOverride;
  GoogleSignIn? _googleOverride;

  GoTrueClient get _auth =>
      (_clientOverride ?? Supabase.instance.client).auth;

  GoogleSignIn get _google => _googleOverride ??= GoogleSignIn(
        // The web client ID makes Google return an ID token for Supabase.
        serverClientId: SupabaseConfig.googleWebClientId.isEmpty
            ? null
            : SupabaseConfig.googleWebClientId,
        scopes: const ['email', 'profile'],
      );

  User? get currentUser => _auth.currentUser;

  /// The signed-in user's id (a Supabase UUID), or null.
  String? get currentUserId => currentUser?.id;

  /// The signed-in user's email, or null. Email lives only in auth, not in
  /// `profiles`.
  String? get currentEmail => currentUser?.email;

  bool get isSignedIn => _auth.currentSession != null;

  /// Sign-in, sign-out, token refresh and password-recovery events.
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  /// Email sign-up. [firstName] / [lastName] go into the user metadata the
  /// profile trigger reads.
  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final res = await _auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: SupabaseConfig.loginRedirect,
      data: {'first_name': firstName, 'last_name': lastName},
    );
    return res.session == null
        ? SignUpOutcome.confirmEmail
        : SignUpOutcome.signedIn;
  }

  /// Email sign-in. The password is sent exactly as typed.
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) =>
      _auth.signInWithPassword(email: email, password: password);

  /// Native Google sign-in: the Google account picker, then the ID token is
  /// exchanged with Supabase.
  Future<GoogleSignInResult> signInWithGoogle() async {
    try {
      final account = await _google.signIn();
      if (account == null) return GoogleSignInResult.cancelled;
      final tokens = await account.authentication;
      final idToken = tokens.idToken;
      if (idToken == null) {
        AppLog.error(
          'googleSignIn',
          StateError('No ID token from Google: is GOOGLE_WEB_CLIENT_ID set?'),
        );
        await _signOutOfGoogle();
        return GoogleSignInResult.failed;
      }
      await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: tokens.accessToken,
      );
      return GoogleSignInResult.success;
    } catch (e, stack) {
      AppLog.error('googleSignIn', e, stack);
      // Next attempt shows the account picker again.
      await _signOutOfGoogle();
      return GoogleSignInResult.failed;
    }
  }

  /// Emails a reset link that opens the app's Set New Password screen.
  Future<void> sendPasswordReset(String email) => _auth.resetPasswordForEmail(
        email,
        redirectTo: SupabaseConfig.resetPasswordRedirect,
      );

  /// Sets a new password for the signed-in (or recovering) user.
  Future<void> updatePassword(String password) =>
      _auth.updateUser(UserAttributes(password: password));

  /// Signs out of Supabase and of Google, so the next Google sign-in lets
  /// the user pick an account.
  Future<void> signOut() async {
    await _signOutOfGoogle();
    await _auth.signOut();
  }

  Future<void> _signOutOfGoogle() async {
    try {
      await _google.signOut();
    } catch (e, stack) {
      AppLog.error('googleSignOut', e, stack);
    }
  }
}
