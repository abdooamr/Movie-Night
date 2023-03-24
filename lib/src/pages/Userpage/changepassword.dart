import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:Movie_Night/src/widgets/iconwidget.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

Future change_password() async {
  await FirebaseAuth.instance
      .sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser!.email!);
}

class _ChangepasswordState extends State<Changepassword> {
  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      //colorxz: Theme.of(context).listTileTheme.tileColor,
      title: 'Privacy',
      leading: Iconwidget(icon: Icons.security, color: Colors.red),
      child: SettingsScreen(
        title: "Change Password",
        children: <Widget>[Change_password(context)],
      ),
    );
  }

  Widget Change_password(BuildContext context) => SimpleSettingsTile(
        //colorxz: Theme.of(context).listTileTheme.tileColor,
        title: "Change Password",
        subtitle: "",
        onTap: () {
          try {
            change_password();
            final snackBarx = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: "Success",
                message: 'Password reset link sent to your email',
                contentType: ContentType.success,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBarx);
          } catch (e) {
            final snackBarx = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Error',
                message: 'Error please log in again and try again',
                contentType: ContentType.failure,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBarx);
          }
        },
        leading: Iconwidget(icon: Icons.password, color: Colors.red),
      );
}
