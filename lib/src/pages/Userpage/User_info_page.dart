import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:Movie_Night/src/widgets/iconwidget.dart';

class userinfowid extends StatelessWidget {
  const userinfowid({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      colorxz: Theme.of(context).listTileTheme.tileColor,
      title: 'Account Info',
      subtitle: '',
      leading: Iconwidget(icon: Icons.person, color: Colors.green),
      child: Scaffold(
        body: User_update_info_page(),
      ),
    );
  }
}
