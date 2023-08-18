import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/components/allcomp.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final prrfilepicture = "https://ui-avatars.com/api/?name=";
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _FirstNameController = TextEditingController();
  final _LastNameController = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  final _displaynamecontroller = TextEditingController();
  final _uidcontroller = TextEditingController();
  var x = '';
  final userrole = "User";
  final emailvalidation =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final passwordvalidation =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  @override
  void dispose() {
    _FirstNameController.dispose();
    _LastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordcontroller.dispose;
    _displaynamecontroller.dispose();
    super.dispose();
  }

  bool passwordconfiremed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordcontroller.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var user_Provider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 32, 26, 48),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: customtext(
                        Texts: S.of(context).createaccountlabel,
                        textsize: 35,
                        weight: FontWeight.bold),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: customtext(
                          Texts: S.of(context).pleasefillallfields,
                          textsize: 15,
                          weight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Customvalformfield(
                          labelText: S.of(context).Usernamelabel,
                          controller: _displaynamecontroller,
                          obscureText: false,
                          iconshape: Icons.person,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Customvalformfield(
                          labelText: S.of(context).firstnamelabel,
                          controller: _FirstNameController,
                          obscureText: false,
                          iconshape: Icons.person,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Customvalformfield(
                          labelText: S.of(context).lastnamelabel,
                          controller: _LastNameController,
                          obscureText: false,
                          iconshape: Icons.person,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Customvalformfield(
                            labelText: S.of(context).emailaddresslabel,
                            controller: _emailController,
                            obscureText: false,
                            validation: emailvalidation,
                            iconshape: Icons.email,
                            valitext: "Please enter a valid email address"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Customvalformfield(
                            labelText: S.of(context).passwordlabel,
                            controller: _passwordController,
                            validation: passwordvalidation,
                            obscureText: true,
                            iconshape: Icons.lock,
                            valitext: S.of(context).passwordvalidationtext),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Customvalformfield(
                          labelText: S.of(context).passwordconfirmlabel,
                          controller: _confirmpasswordcontroller,
                          obscureText: true,
                          iconshape: Icons.lock,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        SizedBox(
                          height: 60,
                          width: 160,
                          child: Consumer<UserProvider>(
                              builder: (context, userProvider, child) {
                            return ElevatedButton.icon(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  final user = Users(
                                    password: _passwordController.text,
                                    role: userrole,
                                    ProfilePic:
                                        "https://ui-avatars.com/api/?name=${_FirstNameController.text}+${_LastNameController.text}",
                                    firstName: _FirstNameController.text,
                                    lastName: _LastNameController.text,
                                    email: _emailController.text,
                                  );

                                  user_Provider.createUser(user: user);

                                  _FirstNameController.clear();
                                  _LastNameController.clear();
                                  _emailController.clear();
                                  _uidcontroller.clear();
                                }
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.app_registration_rounded,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              label: Text(S.of(context).signupbuttonlabel,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 49, 39, 112),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        40)), // This is what you need!
                              ),
                            );
                          }),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customtext(
                                Texts: S.of(context).alreadyhaveanaccountlabel,
                                textsize: 20),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return Login();
                                    }),
                                  );
                                },
                                child: Text(
                                  S.of(context).loginbuttonlabel,
                                  style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    color: Colors.deepPurpleAccent,
                                    fontSize: 20,
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
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
