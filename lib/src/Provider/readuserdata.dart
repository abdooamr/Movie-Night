import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserData extends ChangeNotifier {
  Users? _user;
  Users? get user => _user;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Users?> getUserDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        print(userData['firstName']);
        return Users(
          id: userData['id'],
          role: userData['role'],
          ProfilePic: userData['ProfilePic'],
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          email: userData['email'],
          report: userData['report'],
        );
      } else {
        return null;
      }
    });
  }

  Future<void> updateimage(String uid, User currentuser) async {
    String profileimageUrl = '';
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(File(file.path));
      profileimageUrl = await referenceImageToUpload.getDownloadURL();
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "ProfilePic": profileimageUrl,
      });
      //print(Userrr.photoURL);
      currentuser.updatePhotoURL(profileimageUrl);
      notifyListeners();
    } catch (error) {
      //Some error occurred
    }
  }

  Future updateuser(User Userrr, String Displayname, String firstname,
      String lastname) async {
    await Userrr.updateDisplayName(
      Displayname,
    );
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Userrr.uid)
        .update({
      "firstName": firstname,
      "lastName": lastname,
    });
    await Userrr.reload();
  }
}
