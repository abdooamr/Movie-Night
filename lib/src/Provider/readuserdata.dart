import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserData extends ChangeNotifier {
  Users? _user;
  Users? get user => _user;

  final UserRepository _users = UserRepository.instance;

  Stream<Users?> getUserDataStream(String uid) => _users.userStream(uid);

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
      await _users.updateProfilePic(uid, profileimageUrl);
      //print(Userrr.photoURL);
      currentuser.updatePhotoURL(profileimageUrl);
      notifyListeners();
    } catch (error, stack) {
      AppLog.error('updateProfilePic', error, stack);
      rethrow; // caller shows the failure
    }
  }

  Future updateuser(User Userrr, String Displayname, String firstname,
      String lastname) async {
    await Userrr.updateDisplayName(
      Displayname,
    );
    await _users.updateNames(Userrr.uid,
        firstName: firstname, lastName: lastname);
    await Userrr.reload();
  }
}
