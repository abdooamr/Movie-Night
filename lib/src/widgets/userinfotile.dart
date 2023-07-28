import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class userinfotile extends StatelessWidget {
  final userx = FirebaseAuth.instance.currentUser!;
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _readsomeUsers() =>
      FirebaseFirestore.instance
          .collection('users')
          .where("id", isEqualTo: userx.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
      stream: _readsomeUsers(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final docs = snapshot.data!;
          return ListView(
              shrinkWrap: true,
              children: docs.map((doc) {
                final user = Users(
                    id: doc.data()['id'],
                    role: doc.data()['role'],
                    firstName: doc.data()["first name"],
                    lastName: doc.data()["last name"],
                    ProfilePic: doc.data()["ProfilePic"],
                    email: doc.data()["email"]);
                return buildUser(user, context);
              }).toList());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildUser(Users user, BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).listTileTheme.tileColor,

      title: Text(
        'Hey ' + user.firstName + ' ' + user.lastName,
        style: TextStyle(fontSize: 20),
      ),

      subtitle: Text(user.email, style: TextStyle(fontSize: 15)),
      //leading: Image.network(user.ProfilePic!),
      leading: user.ProfilePic == ""
          ? Icon(Icons.person, size: 30)
          : CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.ProfilePic),
            ),
    );
  }
}
