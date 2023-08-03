// ignore_for_file: body_might_complete_normally_catch_error

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:Movie_Night/src/components/allcomp.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:Movie_Night/src/services/googleauth.dart';

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 32, 26, 48),
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
                    "Login",
                    style: TextStyle(
                        fontFamily: 'Pacifico',
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Please sign in to continue",
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
                          labelText: "Email",
                          controller: _emailController,
                          obscureText: false,
                          validation: emailvalidation,
                          iconshape: Icons.email,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Customvalformfield(
                          labelText: "Password",
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
                            },
                            icon: Icon(
                              IconsaxBold.login_1,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Sign In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 49, 39, 112),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      40)), // This is what you need!
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ForgetNew();
                                }),
                              );
                            },
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                fontFamily: 'Pacifico',
                                color: Colors.deepPurpleAccent,
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
                                      googleauth().signInWithGoogle();
                                      Navigator.pop(context);
                                    },
                                    imagePath: 'images/google.png'),
                              ]),
                        ),
                        Row(
                          children: [
                            Text(
                              "Not a member? ",
                              style: TextStyle(
                                  fontFamily: 'Pacifico',
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return Register();
                                    }),
                                  );
                                },
                                child: Text(
                                  'Register now',
                                  style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    color: Colors.deepPurpleAccent,
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
