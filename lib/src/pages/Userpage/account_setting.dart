import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/pages/Userpage/changepassword.dart';
import 'package:Movie_Night/src/Animation/CustomNavigationAnimation.dart';
import 'package:Movie_Night/src/widgets/changelangwidget.dart';
import 'package:Movie_Night/src/widgets/settingsscreenwidget.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:Movie_Night/src/widgets/iconwidget.dart';
import 'package:provider/provider.dart';

class Accountpage extends StatelessWidget {
  const Accountpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DropdownProvider>(builder: (context, dropdownProvider, _) {
      return Scaffold(
        appBar: AppBar(
          titleTextStyle: Theme.of(context).textTheme.titleLarge!,
          iconTheme: IconThemeData(
              color: Theme.of(context).textTheme.bodyLarge!.color),
          title: Text(S.of(context).accountsettingslabel),
        ),
        body: Column(
          children: <Widget>[
            accountinfo(context),
            privacysettings(context),
            changelanguage(context), // Pass dropdownProvider here

            //Privacyset(context),
          ],
        ),
      );
    });
  }

  Widget accountinfo(BuildContext context) => CustomSettingsTile(
        title: S.of(context).accountinfolabel,
        subtitle: "",
        onTap: () {
          PageTransitionBuilder.navigateWithCustomTransition(
              context, User_update_info_page());
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => User_update_info_page()),
          // );
        },
        leading: Iconwidget(icon: Icons.info, color: Colors.green),
      );
  Widget privacysettings(BuildContext context) => CustomSettingsTile(
        title: S.of(context).privacylabel,
        leading: Iconwidget(icon: Icons.security, color: Colors.red),
        onTap: () {
          PageTransitionBuilder.navigateWithCustomTransition(
              context, Changepassword());
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => Changepassword()),
          // );
        },
      );

  Widget changelanguage(BuildContext context) =>
      Consumer<DropdownProvider>(builder: (context, dropdownProvider, _) {
        return CustomSettingsTile(
          title: S.of(context).changelanguagelabel,
          subtitle: "",
          onTap: () {
            PageTransitionBuilder.navigateWithCustomTransition(
                context, Change_language_widget());
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => Change_language_widget()),
            // );
          },
          leading: Iconwidget(icon: Icons.language, color: Colors.green),
        );
      });
}
