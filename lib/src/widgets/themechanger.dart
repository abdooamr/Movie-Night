// import 'package:Movie_Night/generated/l10n.dart';
// import 'package:Movie_Night/src/Provider/allproviders.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DarkModeSwitch extends StatelessWidget {
//   const DarkModeSwitch({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var themeProvider = Provider.of<ThemeProvider>(context);
//     return SwitchListTile.adaptive(
//       title: Text(
//         S.of(context).darkmodelabel,
//         style: TextStyle(fontSize: 20),
//       ),
//       value: themeProvider.isDarkMode,
//       secondary: Icon(Icons.dark_mode, size: 35),
//       onChanged: (value) async {
//         final provider = Provider.of<ThemeProvider>(context, listen: false);
//         provider.toggleTheme(value);
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setBool('darkMode', value);
//       },
//     );
//   }
// }
