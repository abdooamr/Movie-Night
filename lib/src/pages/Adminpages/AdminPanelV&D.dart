import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/pages/Adminpages/details%20category.dart';

class adminpanel extends StatelessWidget {
  final userrx = FirebaseAuth.instance.currentUser;
  final report = "";
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _readUsers() =>
      FirebaseFirestore.instance
          .collection('users')
          .orderBy("email")
          .snapshots()
          .map((snapshot) => snapshot.docs);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Admin Panel")),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        stream: _readUsers(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final docs = snapshot.data!;
            return ListView(
                children: docs.map((doc) {
              final user = Users(
                  id: doc.data()['id'],
                  role: doc.data()['role'],
                  firstName: doc.data()["first name"],
                  lastName: doc.data()["last name"],
                  ProfilePic: doc.data()["ProfilePic"],
                  report: doc.data()["report"],
                  email: doc.data()["email"]);

              return buildUser(user, context);
            }).toList());
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }

  Widget buildUser(Users user, BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okbutton = TextButton(
      child: Text("ok"),
      onPressed: () {
        _deleteUser(user.id);
        Navigator.pop(context);
      },
    );
    return Row(
      children: [
        //Seachadmin,
        Expanded(
          child: SingleChildScrollView(
            child: Slidable(
              endActionPane:
                  ActionPane(motion: const ScrollMotion(), children: [
                SlidableAction(
                  onPressed: (context) {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text('Delete User'),
                              content: Text(
                                'ARE YOU SURE YOU WANT TO DELETE THE USER? ',
                                style: TextStyle(color: Colors.red),
                              ),
                              actions: [cancelButton, okbutton],
                            ));
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: "Delete",
                )
              ]),
              child: Card(
                color: Color.fromARGB(255, 46, 170, 85),
                borderOnForeground: true,
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detailscategory(
                                      id: user.id,
                                      firstname: user.firstName,
                                      lastname: user.lastName,
                                      email: user.email,
                                      role: user.role,
                                      profilepic: user.ProfilePic,
                                      report: user.report,
                                    )));
                      },
                      leading: user.ProfilePic == ""
                          ? Icon(Icons.person, size: 50)
                          : CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(user.ProfilePic),
                            ),
                      title: Text(user.firstName + " " + user.lastName,
                          style: Theme.of(context).textTheme.bodyLarge),
                      subtitle: Text(
                        user.email,
                        style:
                            TextStyle(color: Colors.orangeAccent, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _deleteUser(String? id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .delete();
  }
}
