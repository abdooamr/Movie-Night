import 'package:flutter/material.dart';
import 'package:Movie_Night/src/Provider/Theme_provider.dart';
import 'package:provider/provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //----First we want to get the theme provider----
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      //---isDarkMode to return if its dark or not--true or false--
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
      activeColor: themeProvider.isDarkMode ? Colors.purple : Colors.green,
    );
  }
}
