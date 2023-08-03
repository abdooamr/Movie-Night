import 'package:Movie_Night/src/pages/Adminpages/add_admin.dart';
import 'package:flutter/material.dart';
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
    super.key,
    this.id,
    this.email,
    this.firstname,
    this.profilepic,
    this.lastname,
    this.report,
    this.role,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(child: Text('Details category')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Details category',
              style: TextStyle(fontFamily: 'Pacifico', fontSize: 40)),
          Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Report_screen(
                                id: id,
                                email: email,
                                firstname: firstname,
                                profilepic: profilepic,
                                lastname: lastname,
                                role: role,
                                report: report)));
                  },
                  child: Text("View Reports"))),
          SizedBox(
            height: 20,
          ),
          Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Fulldetail(
                                id: id,
                                email: email,
                                firstname: firstname,
                                profilepic: profilepic,
                                lastname: lastname,
                                role: role,
                                report: report)));
                  },
                  child: Text("View Full Details"))),
          Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Add_admin(
                                id: id,
                                email: email,
                                firstname: firstname,
                                profilepic: profilepic,
                                lastname: lastname,
                                role: role,
                                report: report)));
                  },
                  child: Text("Add admin"))),
        ],
      ),
    );
  }
}
