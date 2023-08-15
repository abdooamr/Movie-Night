import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/pages/Userpage/Watchlist.dart';
import 'package:Movie_Night/src/widgets/themechanger.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:Movie_Night/src/widgets/allwidget.dart';
import 'package:Movie_Night/src/widgets/userinfotile.dart';
import 'package:in_app_review/in_app_review.dart';

class settings_screen extends StatefulWidget {
  const settings_screen({super.key});

  @override
  State<settings_screen> createState() => _settings_screenState();
}

class _settings_screenState extends State<settings_screen> {
  final Userx = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? isadmin;
  String role = "";
  final userx = FirebaseAuth.instance.currentUser;
  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> _openStoreReview(BuildContext context) async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
      await _inAppReview.openStoreListing();
    } else {
      // Handle the case where in-app reviews are not available
      // You can provide an alternative way for users to leave feedback
    }
  }

  Future Delete_account() async {
    // add the data to fire base
    await _firestore.collection('users').doc(userx!.uid).delete();
  }

  Future checkisadmin() async {
    await _firestore.collection("users").doc(userx!.uid).get().then((value) {
      role = value.data()!['role'];
      if (role == "admin") {
        setState(() {
          isadmin = true;
        });
      } else {
        setState(() {
          isadmin = false;
        });
      }
    });
  }

  @override
  void initState() {
    checkisadmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: userinfotile(),
          ),

          SizedBox(
            height: 10,
          ),
          DarkModeSwitch(),

          (isadmin == true)
              ? SettingsGroup(
                  title: S.of(context).adminsettingslabel,
                  children: <Widget>[
                      SimpleSettingsTile(
                        //colorxz: Theme.of(context).listTileTheme.tileColor,
                        title: S.of(context).adminpanellabel,
                        subtitle: "",
                        leading: Iconwidget(
                            icon: Icons.admin_panel_settings,
                            color: Color.fromARGB(255, 57, 138, 99)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => adminpanel()));
                        },
                      ),
                    ])
              : Container(),
          //SettingsGroup(title: "", children: <Widget>[]),
          SettingsGroup(
              title: S.of(context).generalsettingslabel,
              children: <Widget>[
                watchlist(),
                Accountpage(),
                reportmeth(),
                feedbackmeth(),
              ]),
          SettingsGroup(
              title: S.of(context).managesettingslabel,
              children: <Widget>[
                Logoutmeth(),
                Deletemeth(),
              ])
        ],
      )),
    );
  }

  Widget watchlist() => SimpleSettingsTile(
        //colorxz: Theme.of(context).listTileTheme.tileColor,
        title: S.of(context).watchlistlabel,
        subtitle: "",
        leading: Iconwidget(icon: IconsaxBold.bookmark, color: Colors.purple),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => userwatchlist()));
        },
      );

  Widget reportmeth() => SimpleSettingsTile(
        //colorxz: Theme.of(context).listTileTheme.tileColor,
        title: S.of(context).reportabuglabel,
        subtitle: "",
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SendReport()));
        },
        leading: Iconwidget(
            icon: Icons.bug_report, color: Color.fromARGB(255, 57, 138, 99)),
      );
  Widget feedbackmeth() => SimpleSettingsTile(
        //colorxz: Theme.of(context).listTileTheme.tileColor,
        title: S.of(context).sendfeedbacklabel,
        subtitle: "",
        leading: Iconwidget(icon: Icons.thumb_up, color: Colors.purple),
        onTap: () {
          _openStoreReview(context); // Call the review function here
        },
      );
  Widget Logoutmeth() => SimpleSettingsTile(
        //colorxz: Theme.of(context).listTileTheme.tileColor,
        title: S.of(context).logoutlabel,
        subtitle: "",
        leading: Iconwidget(icon: Icons.logout, color: Colors.blue),
        onTap: () {
          FirebaseAuth.instance.signOut();
        },
      );
  Widget Deletemeth() => SimpleSettingsTile(
        //colorxz: Theme.of(context).listTileTheme.tileColor,
        title: S.of(context).deleteaccountlabel,
        titleTextStyle: TextStyle(
            color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
        subtitle: "",
        leading: Iconwidget(icon: Icons.delete, color: Colors.red),
        onTap: () {
          Userx.delete().catchError((e) {
            final snackBarx = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: "Error",
                message: 'Error please log in again and try again',
                contentType: ContentType.failure,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBarx);
          });
          Delete_account();
        },
      );
  Widget admin_panel() => SimpleSettingsTile(
        //colorxz: Theme.of(context).listTileTheme.tileColor,
        title: S.of(context).adminpanellabel,
        subtitle: "",
        leading:
            Iconwidget(icon: Icons.admin_panel_settings, color: Colors.purple),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => adminpanel()));
        },
      );
}
