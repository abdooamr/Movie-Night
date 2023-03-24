import 'package:Movie_Night/src/pages/Userpage/changepassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:Movie_Night/src/widgets/iconwidget.dart';

class Accountpage extends StatelessWidget {
  const Accountpage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      //colorxz: Theme.of(context).listTileTheme.tileColor,
      title: 'account settings',
      subtitle: 'Edit account, Privacy',
      leading: Iconwidget(icon: Icons.person, color: Colors.green),
      child: SettingsScreen(
        title: "account settings",
        children: <Widget>[
          userinfowid(),
          Changepassword(),
          //Privacyset(context),
        ],
      ),
    );
  }

  Widget accountinfo(BuildContext context) => SimpleSettingsTile(
        //colorxz: Theme.of(context).listTileTheme.tileColor,
        title: "Account Info",
        subtitle: "",
        onTap: () {
          User_update_info_page();
        },
        leading: Iconwidget(icon: Icons.info, color: Colors.green),
      );
}
