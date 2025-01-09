// ignore_for_file: body_might_complete_normally_catch_error
import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/allproviders.dart';
import 'package:Movie_Night/src/Animation/CustomNavigationAnimation.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Movie_Night/src/components/allcomp.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final emailvalidation =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final passwordvalidation =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  Future SignIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .catchError((e) {
      final snackBarx = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message:
              'The password is invalid or the user does not have a password.',
          contentType: ContentType.warning,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBarx); // code, message, details
    });
    ;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user_Provider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge!,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyLarge!.color),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "images/logo.png",
                    scale: 3.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    S.of(context).loginbuttonlabel,
                    style: TextStyle(
                        fontFamily: 'Pacifico',
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    S.of(context).logintocontinue,
                    style: TextStyle(
                        fontFamily: 'Pacifico',
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                  key: formkey,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        Customvalformfield(
                          labelText: S.of(context).emailaddresslabel,
                          controller: _emailController,
                          obscureText: false,
                          validation: emailvalidation,
                          iconshape: Icons.email,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Customvalformfield(
                          labelText: S.of(context).passwordlabel,
                          controller: _passwordController,
                          obscureText: true,
                          validation: passwordvalidation,
                          iconshape: Icons.lock,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 60,
                          width: 160,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              SignIn();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              IconsaxBold.login_1,
                              color: Colors.white,
                            ),
                            label: Text(
                              S.of(context).loginbuttonlabel,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).splashColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      40)), // This is what you need!
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              PageTransitionBuilder
                                  .navigateWithCustomTransition(
                                      context, ForgetNew());
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) {
                              //     return ForgetNew();
                              //   }),
                              // );
                            },
                            child: Text(
                              S.of(context).forgotpasswordlabel,
                              style: TextStyle(
                                fontFamily: 'Pacifico',
                                color: Theme.of(context).splashColor,
                                fontSize: 15,
                              ),
                            )),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // google button
                                Square_Tile(
                                    onTap: () {
                                      user_Provider.signInWithGoogle();
                                      Navigator.pop(context);
                                    },
                                    imagePath: 'images/google.png'),
                              ]),
                        ),
                        Row(
                          children: [
                            Text(
                              S.of(context).notamemberlabel,
                              style: TextStyle(
                                  fontFamily: 'Pacifico',
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            TextButton(
                                onPressed: () {
                                  PageTransitionBuilder
                                      .navigateWithCustomTransition(
                                          context, Register());
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) {
                                  //     return Register();
                                  //   }),
                                  // );
                                },
                                child: Text(
                                  S.of(context).registarnowlabel,
                                  style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    color: Theme.of(context).splashColor,
                                    fontSize: 20,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      //bottomNavigationBar: CustomNavBar(),
    );
  }
}
