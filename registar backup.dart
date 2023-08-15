// // ignore_for_file: body_might_complete_normally_catch_error

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:Movie_Night/src/pages/allpages.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:Movie_Night/src/models/user_model.dart';
// import 'package:Movie_Night/src/services/googleauth.dart';
// import 'package:Movie_Night/src/components/allcomp.dart';

// class Register extends StatefulWidget {
//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   final prrfilepicture = "";
//   final formkey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _FirstNameController = TextEditingController();
//   final _LastNameController = TextEditingController();
//   final _confirmpasswordcontroller = TextEditingController();
//   final _displaynamecontroller = TextEditingController();
//   final _uidcontroller = TextEditingController();
//   var x = '';
//   final userrole = "User";
//   final emailvalidation =
//       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
//   final passwordvalidation =
//       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

//   @override
//   void dispose() {
//     _FirstNameController.dispose();
//     _LastNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmpasswordcontroller.dispose;
//     _displaynamecontroller.dispose();
//     super.dispose();
//   }

//   Future _createUser(Users user, String name, x) async {
//     UserCredential result = await FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//             email: _emailController.text.trim(),
//             password: _passwordController.text.trim())
//         .catchError((e) {
//       final snackBarx = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error',
//           message: 'Sorry this email already exist',
//           contentType: ContentType.warning,
//         ),
//       );
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBarx); // code, message, details
//     });
//     Navigator.pop(context);
//     User? userx = result.user;
//     userx!.updateDisplayName(name);
//     final userDoc =
//         FirebaseFirestore.instance.collection('users').doc(userx.uid);
//     user.id = userDoc.id;
//     user.role = userrole;
//     userx.updatePhotoURL(user.ProfilePic);
//     final json = user.toJson();

//     await userDoc.set(json);
//   }

//   bool passwordconfiremed() {
//     if (_passwordController.text.trim() ==
//         _confirmpasswordcontroller.text.trim()) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       backgroundColor: Color.fromARGB(255, 32, 26, 48),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: customtext(
//                         Texts: "Create Account",
//                         textsize: 35,
//                         weight: FontWeight.bold),
//                   ),
//                   Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: customtext(
//                           Texts: "Please fill the input below here",
//                           textsize: 15,
//                           weight: FontWeight.bold)),
//                   SizedBox(height: 10),
//                   Form(
//                     key: formkey,
//                     child: Column(
//                       children: [
//                         MyTextField(
//                           labelText: "Username",
//                           controller: _displaynamecontroller,
//                           obscureText: false,
//                           iconshape: Icons.person,
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.02,
//                         ),
//                         MyTextField(
//                           labelText: "First name",
//                           controller: _FirstNameController,
//                           obscureText: false,
//                           iconshape: Icons.person,
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.02,
//                         ),
//                         MyTextField(
//                           labelText: "Last name",
//                           controller: _LastNameController,
//                           obscureText: false,
//                           iconshape: Icons.person,
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.02,
//                         ),
//                         Customvalformfield(
//                             labelText: "Email",
//                             controller: _emailController,
//                             obscureText: false,
//                             validation: emailvalidation,
//                             iconshape: Icons.email,
//                             valitext: "Please enter a valid email address"),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.02,
//                         ),
//                         Customvalformfield(
//                           labelText: "Password",
//                           controller: _passwordController,
//                           validation: passwordvalidation,
//                           obscureText: true,
//                           iconshape: Icons.lock,
//                           valitext:
//                               "•Password must be: \n •8 characters long \n •Contain at least one uppercase letter \n •One lowercase letter \n •One special character",
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.02,
//                         ),
//                         MyTextField(
//                           labelText: "Confirm password",
//                           controller: _confirmpasswordcontroller,
//                           obscureText: true,
//                           iconshape: Icons.lock,
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.02,
//                         ),
//                         SizedBox(
//                           height: 60,
//                           width: 160,
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               if (formkey.currentState!.validate()) {
//                                 final user = Users(
//                                   role: userrole,
//                                   ProfilePic: prrfilepicture,
//                                   firstName: _FirstNameController.text,
//                                   lastName: _LastNameController.text,
//                                   email: _emailController.text,
//                                 );
//                                 //print("the updated uid is.............." + x);

//                                 _createUser(user,
//                                     _displaynamecontroller.text.trim(), x);
//                                 _FirstNameController.clear();
//                                 _LastNameController.clear();
//                                 _emailController.clear();
//                                 _uidcontroller.clear();
//                               }
//                             },
//                             icon: Icon(
//                               Icons.app_registration_rounded,
//                               color: Colors.black,
//                             ),
//                             label: Text(
//                               'Sign Up',
//                               style:
//                                   TextStyle(color: Colors.black, fontSize: 20),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       40)), // This is what you need!
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.02,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             customtext(
//                                 Texts: "Already have an account? ",
//                                 textsize: 20),
//                             TextButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) {
//                                       return Login();
//                                     }),
//                                   );
//                                 },
//                                 child: Text(
//                                   'Log In',
//                                   style: TextStyle(
//                                     fontFamily: 'Pacifico',
//                                     color: Colors.red,
//                                     fontSize: 20,
//                                   ),
//                                 )),
//                           ],
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.02,
//                         ),
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // google button
//                               Square_Tile(
//                                   onTap: () {
//                                     googleauth().signInWithGoogle();
//                                     Navigator.pop(context);
//                                   },
//                                   imagePath: 'images/google.png'),
//                             ]),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       //bottomNavigationBar: CustomNavBar(),
//     );
//   }
// }
