import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}

class MyThemes {
  //-------------DARK THEME SETTINGS----
  static final darkTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Color(0xFF171823),
      brightness: Brightness.dark,
      fontFamily: 'poppins',
      listTileTheme: const ListTileThemeData(tileColor: Color(0xFF171823)),
      iconTheme: const IconThemeData(color: Colors.white),
      cardColor: Color.fromARGB(255, 28, 28, 30),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade500),
      textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
      pageTransitionsTheme: const PageTransitionsTheme(
          builders: {TargetPlatform.android: ZoomPageTransitionsBuilder()})
      // colorScheme:  ColorScheme.dark(),
      );

  //-------------light THEME SETTINGS----
  static final lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      fontFamily: 'poppins',
      listTileTheme: const ListTileThemeData(tileColor: Colors.white),
      iconTheme: const IconThemeData(color: Colors.black),
      cardColor: Color.fromARGB(255, 86, 60, 133),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.shade500),
      textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
      pageTransitionsTheme: const PageTransitionsTheme(
          builders: {TargetPlatform.android: ZoomPageTransitionsBuilder()})
      //colorScheme:  ColorScheme.light(),
      );
}
