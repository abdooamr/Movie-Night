import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movietest1/pages/Login-Logout/Login.dart';
import 'package:movietest1/pages/Login-Logout/Register.dart';
import 'package:movietest1/pages/Login-Logout/Forget_password.dart';

class loWelcomeScreen extends StatelessWidget {
  const loWelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /*
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/NBack1.jpg"), fit: BoxFit.fill),
            ),
          ),
          */
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 25),
                  child: Column(
                    children: [
                      Text(
                        'Hello',
                        style: GoogleFonts.pacifico(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'Welcome back ',
                        style: GoogleFonts.pacifico(
                            fontSize: 25, color: Colors.grey.shade100),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  children: [
                    /*
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 25, left: 24, right: 24),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Color.fromARGB(255, 186, 0, 35)),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    */
                    SingleChildScrollView(
                      child: Row(children: [
                        Image.asset(
                          "images/movie-countdown-venom.gif",
                          scale: 2.5,
                        ),
                        Image.asset(
                          "images/its-movie-time-chatime.gif",
                          scale: 2.5,
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 25, left: 24, right: 24),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Color.fromARGB(255, 186, 0, 35)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return LoginNew();
                            }),
                          );
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 25, left: 24, right: 24),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Color.fromARGB(255, 186, 0, 35)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return RegisterNew();
                            }),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      //bottomNavigationBar: CustomNavBar(),
    );
  }
}
