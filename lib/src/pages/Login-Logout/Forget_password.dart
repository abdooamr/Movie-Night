import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetNew extends StatefulWidget {
  @override
  _ForgetNewState createState() => _ForgetNewState();
}

class _ForgetNewState extends State<ForgetNew> {
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future PasswordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge!,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyLarge!.color),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SizedBox(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Forget Password ?",
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
                        "Enter the email associated with your account",
                        style: TextStyle(
                            fontFamily: 'Pacifico',
                            color: Theme.of(context).hintColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  fillColor: Color.fromARGB(255, 56, 48, 76),
                                  filled: true,
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 60,
                            width: 160,
                            child: ElevatedButton(
                              onPressed: () {
                                PasswordReset();
                              },
                              child: Text(
                                'Send Email',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).splashColor,
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
      ),
      //bottomNavigationBar: CustomNavBar(),
    );
  }
}
