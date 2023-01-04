import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movietest1/pages/Userpage/profilepic.dart';

class Userpage extends StatefulWidget {
  const Userpage({super.key});

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  String? firstname;
  final User = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(child: Text("Profile")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            ProfilePic(),
            SizedBox(height: 20),
            Text(User.displayName!),
            ProfileMenu(
              icon: "images/User Icon.svg",
              text: "My account",
              press: () {},
            ),
            ProfileMenu(
              icon: "images/Heart Icon.svg",
              text: "Likes",
              press: () {},
            ),
            ProfileMenu(
              icon: "images/Settings.svg",
              text: "Settings",
              press: () {},
            ),
            ProfileMenu(
              icon: "images/Log out.svg",
              text: "Log Out",
              press: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    ); // Column
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),

        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
              color: Color.fromARGB(255, 186, 0, 35),
            ), // SvgPicture.asset
            SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
              style: TextStyle(color: Color.fromARGB(255, 186, 0, 35)),
            )),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ],
        ), // Row
      ), // FlatButton
    );
  }
}
