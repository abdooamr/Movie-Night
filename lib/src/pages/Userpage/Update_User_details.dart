import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/components/allcomp.dart';
import 'package:Movie_Night/src/pages/allpages.dart';

class User_update_info_page extends StatefulWidget {
  @override
  _User_update_info_pageState createState() => _User_update_info_pageState();
}

class _User_update_info_pageState extends State<User_update_info_page> {
  final formkey = GlobalKey<FormState>();
  final _FirstNameController = TextEditingController();
  final _LastNameController = TextEditingController();
  final _displaynamecontroller = TextEditingController();
  final Userrr = FirebaseAuth.instance.currentUser!;

  Future updateuser() async {
    await Userrr.updateDisplayName(
      _displaynamecontroller.text,
    );
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Userrr.uid)
        .update({
      "first name": _FirstNameController.text,
      "last name": _LastNameController.text,
    });
    await Userrr.reload();
  }

  @override
  void dispose() {
    _FirstNameController.dispose();
    _LastNameController.dispose();
    _displaynamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: customtext(
                        Texts: "Update Account",
                        textsize: 35,
                        weight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ProfilePic(),
                  ),
                  SizedBox(height: 60),
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        MyTextField(
                          labelText: "Username",
                          controller: _displaynamecontroller,
                          obscureText: false,
                          iconshape: Icons.person,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _FirstNameController,
                          iconshape: Icons.person,
                          labelText: "First name",
                          obscureText: false,
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          controller: _LastNameController,
                          iconshape: Icons.person,
                          labelText: "Last name",
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 60,
                          width: 160,
                          child: ElevatedButton(
                            onPressed: () {
                              updateuser();
                              final snackBarx = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: "Success",
                                  message:
                                      'The User data has been updated successfully',
                                  contentType: ContentType.success,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBarx);
                            },
                            child: Text(
                              'Edit Profile',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      40)), // This is what you need!
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      //bottomNavigationBar: CustomNavBar(),
    );
  }
}
