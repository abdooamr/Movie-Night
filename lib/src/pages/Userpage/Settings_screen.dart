import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/pages/Userpage/Watchlist.dart';
import 'package:Movie_Night/src/widgets/themechanger.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:Movie_Night/src/widgets/allwidget.dart';
import 'package:Movie_Night/src/widgets/userinfotile.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Userx = FirebaseAuth.instance.currentUser!;
  final UserRepository _users = UserRepository.instance;
  bool? isadmin;
  final userx = FirebaseAuth.instance.currentUser;
  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> _openStoreReview(BuildContext context) async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
      await _inAppReview.openStoreListing();
    } else {
      // In-app review unavailable (emulator, not on store): go to the store page.
      try {
        await _inAppReview.openStoreListing();
      } catch (e, st) {
        AppLog.error('openStoreListing', e, st);
        Fluttertoast.showToast(msg: S.of(context).genericError);
      }
    }
  }

  Future Delete_account() async {
    await _users.deleteUserDocument(userx!.uid);
  }

  Future checkisadmin() async {
    bool admin;
    try {
      admin = await _users.isAdmin(userx!.uid);
    } catch (_) {
      admin = false;
    }
    if (mounted) setState(() => isadmin = admin);
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
                        showDivider: false,
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
        showDivider: false,
        title: S.of(context).watchlistlabel,
        subtitle: "",
        leading: Iconwidget(icon: IconsaxBold.bookmark, color: Colors.purple),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UserWatchlist()));
        },
      );

  Widget reportmeth() => SimpleSettingsTile(
        showDivider: false,
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
        showDivider: false,
        title: S.of(context).sendfeedbacklabel,
        subtitle: "",
        leading: Iconwidget(icon: Icons.thumb_up, color: Colors.purple),
        onTap: () {
          _openStoreReview(context); // Call the review function here
        },
      );
  Widget Logoutmeth() => SimpleSettingsTile(
        showDivider: false,
        title: S.of(context).logoutlabel,
        subtitle: "",
        leading: Iconwidget(icon: Icons.logout, color: Colors.blue),
        onTap: () {
          FirebaseAuth.instance.signOut();
        },
      );
  Widget Deletemeth() => SimpleSettingsTile(
        showDivider: false,
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
                title: S.of(context).errorTitle,
                message: S.of(context).errorLoginAgain,
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
        showDivider: false,
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
