import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/components/allcomp.dart';
import 'package:Movie_Night/src/pages/allpages.dart';

class Add_admin extends StatefulWidget {
  Add_admin({
    super.key,
    this.id,
    this.email,
    this.firstname,
    this.lastname,
    this.profilepic,
    this.report,
    this.role,
  });
  final String? id;
  final String? email;
  final String? firstname;
  final String? profilepic;
  final String? lastname;
  String? role;
  final String? report;

  @override
  State<Add_admin> createState() => _Add_adminState();
}

class _Add_adminState extends State<Add_admin> {
  final reportclear = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userx = FirebaseAuth.instance.currentUser;

  Future addadmin() async {
    // add the data to fire base
    setState(() {
      _firestore.collection("users").doc(widget.id).update({
        "role": "admin",
      });
      widget.role = "admin";
    });
  }

  Future removeadmin() async {
    // add the data to fire base
    setState(() {
      widget.role = "user";
      _firestore.collection("users").doc(widget.id).update({
        "role": "user",
      });
      widget.role = "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Page"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: customtext(
                        Texts: "User Profile",
                        textsize: 35,
                        weight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: (widget.profilepic == "")
                        ? Icon(
                            Icons.person,
                            size: 100,
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(widget.profilepic!),
                          ),
                  ),
                  SizedBox(height: 60),
                  textcustom(
                    Texts:
                        "Name: " + widget.firstname! + " " + widget.lastname!,
                  ),
                  SizedBox(height: 20),
                  textcustom(Texts: "Email: " + widget.email!),
                  textcustom(Texts: "Role: " + widget.role!),
                  (widget.role == "admin")
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          onPressed: () {
                            removeadmin();
                          },
                          child: Text(
                            "Remove Admin",
                          ),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                          onPressed: () {
                            addadmin();
                          },
                          child: Text(
                            "Add Admin",
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
