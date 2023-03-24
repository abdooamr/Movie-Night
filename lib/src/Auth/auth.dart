import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Movie_Night/src/widgets/Navbar/loggedinmainpage.dart';
import 'package:Movie_Night/src/widgets/Navbar/main_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const loggedmainpage();
          } else {
            return const MainPage();
          }
        },
      ),
    );
  }
}
