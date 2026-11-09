import 'package:flutter/foundation.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';

export 'package:Movie_Night/src/data/auth_repository.dart'
    show GoogleSignInResult, SignUpOutcome;

/// Sign-up and Google sign-in for the UI, over [AuthRepository]. The profile
/// row is created by the database trigger from the sign-up metadata.
class UserProvider extends ChangeNotifier {
  AuthRepository get _auth => AuthRepository.instance;

  /// Email sign-up. Returns [SignUpOutcome.confirmEmail] when the account
  /// waits for the confirmation link (no session yet).
  Future<SignUpOutcome> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final outcome = await _auth.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      notifyListeners();
      return outcome;
    } catch (error, stack) {
      AppLog.error('createUser', error, stack);
      rethrow; // The UI shows the failure.
    }
  }

  /// Distinguishes a dismissed account picker from a real failure.
  Future<GoogleSignInResult> signInWithGoogle() => _auth.signInWithGoogle();
}
