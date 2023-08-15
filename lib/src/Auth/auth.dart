import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Movie_Night/src/widgets/Navbar/Navbar.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: Colors.deepPurpleAccent,
              strokeWidth: 3,
            );
          }
          if (snapshot.hasData) {
            return CustomBottomNavigationBar(isSignedIn: true);
          } else {
            return CustomBottomNavigationBar(isSignedIn: false);
          }
        },
      ),
    );
  }
}
