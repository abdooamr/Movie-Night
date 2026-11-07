import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/allproviders.dart';
import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/widgets/shimmerWidgets/userInfoTileShimmerWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class userinfotile extends StatelessWidget {
  userinfotile({super.key});

  final userx = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Users?>(
      stream: Provider.of<UserData>(context, listen: false)
          .getUserDataStream(userx.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const UserInfoTileShimmerWidget();
        } else if (snapshot.hasError) {
          return Center(
              child: Text('${S.of(context).error}: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text(S.of(context).noUserDataAvailable));
        } else {
          return buildUser(snapshot.data!, context);
        }
      },
    );
  }

  Widget buildUser(Users user, BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).listTileTheme.tileColor,
      title: user.lastName == ""
          ? Text(
              '${S.of(context).Heylabel} ${user.firstName}',
              style: const TextStyle(fontSize: 20),
            )
          : Text(
              '${S.of(context).Heylabel} ${user.firstName} ${user.lastName}',
              style: const TextStyle(fontSize: 20),
            ),
      subtitle: Text(user.email, style: const TextStyle(fontSize: 15)),
      leading: user.ProfilePic == ""
          ? const Icon(Icons.person, size: 30)
          : CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.ProfilePic),
            ),
    );
  }
}
