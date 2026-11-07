import 'package:flutter/foundation.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// The single sign-up / Google sign-in path (task 2.8 removed the duplicate
/// `services/googleauth.dart`). Firestore writes go through [UserRepository].
enum GoogleSignInResult { success, cancelled, failed }

class UserProvider extends ChangeNotifier {
  Users? _user;

  Users? get user => _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserRepository get _users => UserRepository.instance;

  Future<void> createUser({
    required Users user,
  }) async {
    try {
      // Create user in FirebaseAuth
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );

      User? firebaseUser = authResult.user;
      if (firebaseUser != null) {
        // Update display name
        await firebaseUser.updateDisplayName(user.firstName + user.lastName);
        await firebaseUser.updatePhotoURL(user.ProfilePic);

        await _users.createUserDocument(firebaseUser.uid, user);

        _user = user;
        notifyListeners();
      }
    } catch (error, stack) {
      AppLog.error('createUser', error, stack);
      rethrow; // Rethrow the error to allow the UI to handle it
    }
  }

  /// Distinguishes a dismissed account picker from a real failure.
  Future<GoogleSignInResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return GoogleSignInResult.cancelled;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) return GoogleSignInResult.failed;

      await _users.ensureGoogleUserDocument(user);
      return GoogleSignInResult.success;
    } catch (e, stack) {
      AppLog.error('googleSignIn', e, stack);
      return GoogleSignInResult.failed;
    }
  }
}
