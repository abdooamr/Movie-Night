import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    super.key,
  });

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final Userrr = FirebaseAuth.instance.currentUser!;
  var userpp = FirebaseAuth.instance.currentUser!.photoURL;
  String profileimageUrl = '';
  Future updateimage() async {
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
      await FirebaseFirestore.instance
          .collection("users")
          .doc(Userrr.uid)
          .update({
        "ProfilePic": profileimageUrl,
      });
      //print(Userrr.photoURL);
      Userrr.updatePhotoURL(profileimageUrl);
    } catch (error) {
      //Some error occurred
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          if (Userrr.photoURL != null)
            CircleAvatar(
              backgroundImage: NetworkImage(Userrr.photoURL!),
            )
          else
            Icon(Icons.person, size: 80),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () async {
                  await updateimage();
                  setState(() {});
                },
                child: Icon(Icons.camera_alt, color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
