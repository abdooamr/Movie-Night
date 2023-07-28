import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Movie_Night/src/pages/allpages.dart';

class loWelcomeScreen extends StatelessWidget {
  const loWelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (p0, p1) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 15),
                  child: Column(
                    children: [
                      Container(
                        height: p1.maxHeight * 0.1,
                        child: Text(
                          'Hello',
                          style: GoogleFonts.pacifico(
                              fontSize: 55,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        height: p1.maxHeight * 0.1,
                        child: Text(
                          'Welcome back ',
                          style: GoogleFonts.pacifico(
                              fontSize: 25, color: Colors.grey.shade100),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    Image.asset(
                      "images/movie-countdown-venom.gif",
                      scale: 2.5,
                      height: p1.maxWidth * 0.5,
                    ),
                    Image.asset(
                      "images/its-movie-time-chatime.gif",
                      scale: 2.5,
                      height: p1.maxWidth * 0.5,
                    ),
                  ]),
                ),
                SizedBox(
                  height: p1.maxHeight * 0.1,
                ),
                Container(
                  height: 80,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 25, left: 24, right: 24),
                  child: ElevatedButton.icon(
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
                    icon: Icon(IconsaxBold.login),
                    label: Text(
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
                  padding: const EdgeInsets.only(top: 25, left: 24, right: 24),
                  child: ElevatedButton.icon(
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
                    icon: Icon(IconsaxBold.user),
                    label: Text(
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
          );
        },
      ),
      //bottomNavigationBar: CustomNavBar(),
    );
  }
}
