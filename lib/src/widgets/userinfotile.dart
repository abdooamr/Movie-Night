import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/allproviders.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class userinfotile extends StatelessWidget {
  final userx = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Users?>(
      stream: Provider.of<UserData>(context, listen: false)
          .getUserDataStream(userx.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).splashColor,
            strokeWidth: 3,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No user data available.'));
        } else {
          return buildUser(snapshot.data!, context);
        }
      },
    );
  }

  Widget buildUser(Users user, BuildContext context) {
    return ListTile(
      tileColor: Colors.transparent,

      title: user.lastName == ""
          ? Text(
              S.of(context).heylabel + " " + user.firstName,
              style: TextStyle(fontSize: 20),
            )
          : Text(
              S.of(context).heylabel +
                  " " +
                  user.firstName +
                  ' ' +
                  user.lastName,
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
