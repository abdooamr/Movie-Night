import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/pages/Userpage/changepassword.dart';
import 'package:Movie_Night/src/widgets/changelangwidget.dart';
import 'package:Movie_Night/src/widgets/customsettingscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:Movie_Night/src/widgets/iconwidget.dart';
import 'package:provider/provider.dart';

class Accountpage extends StatelessWidget {
  const Accountpage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
        title: S.of(context).accountsettingslabel,
        subtitle: S.of(context).accountsettingssubtitle,
        leading: Iconwidget(icon: Icons.person, color: Colors.green),
        child:
            Consumer<DropdownProvider>(builder: (context, dropdownProvider, _) {
          return Settings_Screen(
            title: S.of(context).accountsettingslabel,
            children: <Widget>[
              userinfowid(),
              Changepassword(),
              changelanguage(context), // Pass dropdownProvider here

              //Privacyset(context),
            ],
          );
        }));
  }

  Widget accountinfo(BuildContext context) => SimpleSettingsTile(
        title: S.of(context).accountinfolabel,
        subtitle: "",
        onTap: () {
          User_update_info_page();
        },
        leading: Iconwidget(icon: Icons.info, color: Colors.green),
      );

  Widget changelanguage(BuildContext context) =>
      Consumer<DropdownProvider>(builder: (context, dropdownProvider, _) {
        return SimpleSettingsTile(
          //colorxz: Theme.of(context).listTileTheme.tileColor,
          title: S.of(context).changelanguagelabel,
          subtitle: "",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Change_language_widget()),
            );
          },
          leading: Iconwidget(icon: Icons.language, color: Colors.green),
        );
      });
}
