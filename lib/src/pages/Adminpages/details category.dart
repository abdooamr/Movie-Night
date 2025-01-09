import 'package:Movie_Night/src/Animation/CustomNavigationAnimation.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/pages/Adminpages/add_admin.dart';
import 'package:Movie_Night/src/pages/Adminpages/fulldetails.dart';
import 'package:Movie_Night/src/pages/Adminpages/report_page.dart';

class Detailscategory extends StatelessWidget {
  final String? id;
  final String? email;
  final String? firstname;
  final String? profilepic;
  final String? lastname;
  final String? role;
  final String? report;

  const Detailscategory({
    Key? key,
    this.id,
    this.email,
    this.firstname,
    this.profilepic,
    this.lastname,
    this.report,
    this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge!,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyLarge!.color),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(child: Text('Details Category')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Details Category',
              style: TextStyle(fontFamily: 'Pacifico', fontSize: 40),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).splashColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              onPressed: () {
                PageTransitionBuilder.navigateWithCustomTransition(
                  context,
                  Report_screen(
                    id: id,
                    email: email,
                    firstname: firstname,
                    profilepic: profilepic,
                    lastname: lastname,
                    role: role,
                    report: report,
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => Report_screen(
                //       id: id,
                //       email: email,
                //       firstname: firstname,
                //       profilepic: profilepic,
                //       lastname: lastname,
                //       role: role,
                //       report: report,
                //     ),
                //   ),
                // );
              },
              child: Text("View Reports"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).splashColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              onPressed: () {
                PageTransitionBuilder.navigateWithCustomTransition(
                  context,
                  Fulldetail(
                    id: id,
                    email: email,
                    firstname: firstname,
                    profilepic: profilepic,
                    lastname: lastname,
                    role: role,
                    report: report,
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //   ),
                // );
              },
              child: Text("View Full Details"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).splashColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              onPressed: () {
                PageTransitionBuilder.navigateWithCustomTransition(
                  context,
                  AddAdmin(
                    id: id,
                    email: email,
                    firstname: firstname,
                    profilepic: profilepic,
                    lastname: lastname,
                    role: role,
                    report: report,
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => AddAdmin(
                //       id: id,
                //       email: email,
                //       firstname: firstname,
                //       profilepic: profilepic,
                //       lastname: lastname,
                //       role: role,
                //       report: report,
                //     ),
                //   ),
                // );
              },
              child: Text("Add Admin"),
            ),
          ],
        ),
      ),
    );
  }
}
