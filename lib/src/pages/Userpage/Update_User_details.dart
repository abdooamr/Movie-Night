import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/allproviders.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/components/allcomp.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:provider/provider.dart';

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

  @override
  void dispose() {
    _FirstNameController.dispose();
    _LastNameController.dispose();
    _displaynamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var updateuserdata = Provider.of<UserData>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).updateprofilelabel),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
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
                        Texts: S.of(context).updateaccountlabel,
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
                          labelText: S.of(context).Usernamelabel,
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
                          labelText: S.of(context).firstnamelabel,
                          obscureText: false,
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          controller: _LastNameController,
                          iconshape: Icons.person,
                          labelText: S.of(context).lastnamelabel,
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Consumer<UserData>(
                            builder: (context, UserData, child) {
                              return ElevatedButton(
                                onPressed: () {
                                  updateuserdata.updateuser(
                                      Userrr,
                                      _displaynamecontroller.text,
                                      _FirstNameController.text,
                                      _LastNameController.text);
                                  final snackBarx = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: S.of(context).success,
                                      message:
                                          S.of(context).updateprofilesuccess,
                                      contentType: ContentType.success,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBarx);
                                },
                                child: Text(
                                  S.of(context).editprofilelabel,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                      fontSize: 20),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 49, 39, 112),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          40)), // This is what you need!
                                ),
                              );
                            },
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
