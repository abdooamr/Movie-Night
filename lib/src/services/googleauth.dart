import 'package:Movie_Night/src/components/allcomp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class googleauth {
  final lastnamenothing = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userDoc = FirebaseFirestore.instance.collection('users').doc();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userrole = "User";

  User get userx => _auth.currentUser!;

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
            "role": userrole,
            'email': user.email,
            'firstname': user.displayName,
            'ProfilePic': user.photoURL,
            "lastname": lastnamenothing,
            "id": user.uid,
            "report": " ",
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
