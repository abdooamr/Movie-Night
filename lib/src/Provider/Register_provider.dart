import 'package:Movie_Night/src/components/textcustom.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider extends ChangeNotifier {
  Users? _user;

  Users? get user => _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

        // Create user document in FirebaseFirestore
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'id': firebaseUser.uid,
          'role': user.role,
          'ProfilePic': user.ProfilePic,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'email': user.email,
          'report': "",
        });

        _user = user;
        notifyListeners();
      }
    } catch (error) {
      // Handle error
      rethrow; // Rethrow the error to allow the UI to handle it
    }
  }

  Future<bool> signInWithGoogle() async {
    bool result = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          // add the data to fire base
          await _firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'role': "User",
            'ProfilePic': user.photoURL,
            'firstName': user.displayName!.split(" ")[0],
            'lastName': user.displayName!.split(" ")[1],
            'email': user.email,
            'report': "",
          });
        }
        result = true;
      }
      return result;
    } catch (e) {
      textcustom(
        Texts: e.toString(),
      );
    }
    return result;
  }
}
