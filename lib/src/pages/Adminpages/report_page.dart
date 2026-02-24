// ignore_for_file: must_be_immutable

import 'package:Movie_Night/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/components/allcomp.dart';

class Report_screen extends StatefulWidget {
  Report_screen({
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
  String? report;

  @override
  State<Report_screen> createState() => _Report_screenState();
}

class _Report_screenState extends State<Report_screen> {
  final reportclear = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userx = FirebaseAuth.instance.currentUser;

  Future remove_report() async {
    // add the data to fire base
    setState(() {
      widget.report = "user";
      _firestore.collection("users").doc(widget.id).update({
        "report": "",
      });
      widget.report = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).reportPage),
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
                        Texts: S.of(context).userProfile,
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
                    Texts: "${S.of(context).name}: " +
                        widget.firstname! +
                        " " +
                        widget.lastname!,
                  ),
                  SizedBox(height: 20),
                  textcustom(Texts: "${S.of(context).email}: " + widget.email!),
                  (widget.report == null || widget.report == "")
                      ? textcustom(
                          Texts:
                              "${S.of(context).report}: ${S.of(context).noReport}")
                      : Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 36, 50, 117),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${S.of(context).report}: " + widget.report!,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )),
                        ),
                  (widget.report == null || widget.report == "")
                      ? SizedBox(height: 0)
                      : ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Color.fromARGB(255, 49, 39, 112))),
                          onPressed: () => remove_report(),
                          child: Text(S.of(context).clearReport))
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
