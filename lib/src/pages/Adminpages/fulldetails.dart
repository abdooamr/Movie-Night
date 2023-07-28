import 'package:flutter/material.dart';
import 'package:Movie_Night/src/components/allcomp.dart';

class Fulldetail extends StatelessWidget {
  final String? id;
  final String? email;
  final String? firstname;
  final String? profilepic;
  final String? lastname;
  final String? role;
  final String? report;
  const Fulldetail({
    super.key,
    this.id,
    this.email,
    this.firstname,
    this.lastname,
    this.profilepic,
    this.report,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full User Profile"),
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
                        Texts: "Full User Profile",
                        textsize: 35,
                        weight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: (profilepic == "")
                        ? Icon(
                            Icons.person,
                            size: 100,
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(profilepic!),
                          ),
                  ),
                  SizedBox(height: 60),
                  textcustom(
                    Texts: "Name: " + firstname! + " " + lastname!,
                  ),
                  SizedBox(height: 20),
                  textcustom(Texts: "Email: " + email!),
                  SizedBox(height: 20),
                  textcustom(Texts: "Role: " + role!),
                  SizedBox(height: 20),
                  textcustom(Texts: "ID: " + id!),
                  SizedBox(height: 20),
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
