import 'package:Movie_Night/src/components/colorpalette.dart';
import 'package:flutter/material.dart';

ThemeData createDarkThemeData(
  Color scaffoldBackgroundColor,
  Color tileColor,
  Color cardColor,
  Color splashColor,
  Color highlightColor,
  Color selectedItemColor,
  Color unselectedItemColor,
) {
  return ThemeData(
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    brightness: Brightness.dark,
    fontFamily: 'poppins',
    listTileTheme: ListTileThemeData(tileColor: tileColor),
    iconTheme: IconThemeData(color: Colors.white),
    cardColor: cardColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {TargetPlatform.android: ZoomPageTransitionsBuilder()},
    ),
    splashColor: splashColor,
    highlightColor: highlightColor,
    hintColor: Colors.grey.shade400,
  );
}

final darkThemeData = createDarkThemeData(
  Color(0xFF171823),
  Color(0xFF171823),
  Color.fromARGB(255, 28, 28, 30),
  Colors.deepPurpleAccent.shade400,
  Colors.deepPurpleAccent.shade700,
  Colors.white,
  Colors.grey,
);

final oceanicWavesThemeData = createDarkThemeData(
  Colors.transparent,
  oceanicWavesGradient[0],
  oceanicWavesGradient[1],
  oceanicWavesGradient[1],
  Color.fromARGB(255, 253, 80, 166),
  oceanicWavesGradient[3],
  oceanicWavesGradient[1],
);
final elegantNeutralsThemeData = createDarkThemeData(
  Colors.transparent,
  elegantNeutralsGradient[0],
  elegantNeutralsGradient[1],
  elegantNeutralsGradient[1],
  Color.fromARGB(255, 26, 26, 35),
  elegantNeutralsGradient[2],
  elegantNeutralsGradient[1],
);
final mysticMeadowsThemeData = createDarkThemeData(
  Colors.transparent,
  mysticMeadowsGradient[0],
  mysticMeadowsGradient[1],
  mysticMeadowsGradient[1],
  Color.fromARGB(255, 71, 184, 241),
  mysticMeadowsGradient[3],
  mysticMeadowsGradient[2],
);
final cottonCandyThemeData = createDarkThemeData(
  Colors.transparent,
  cottonCandyGradient[0],
  cottonCandyGradient[1],
  cottonCandyGradient[1],
  Color.fromARGB(255, 255, 58, 176),
  cottonCandyGradient[3],
  cottonCandyGradient[2],
);
final luminousGalaxyThemeData = createDarkThemeData(
  Colors.transparent,
  luminousGalaxyGradient[0],
  luminousGalaxyGradient[1],
  luminousGalaxyGradient[1],
  Colors.deepPurpleAccent,
  Colors.deepPurpleAccent,
  Colors.deepPurpleAccent.shade100,
);

ThemeData createLightThemeData(
  Color scaffoldBackgroundColor,
  Color tileColor,
  Color cardColor,
  Color splashColor,
  Color highlightColor,
  Color selectedItemColor,
  Color unselectedItemColor,
) {
  return ThemeData(
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    brightness: Brightness.light,
    fontFamily: 'poppins',
    listTileTheme: ListTileThemeData(tileColor: tileColor),
    iconTheme: const IconThemeData(color: Colors.black),
    cardColor: cardColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {TargetPlatform.android: ZoomPageTransitionsBuilder()},
    ),
    splashColor: splashColor,
    highlightColor: highlightColor,
    hintColor: Colors.black.withOpacity(0.5),
  );
}

final lightThemeData = createLightThemeData(
  Colors.white,
  Colors.white,
  Color.fromARGB(255, 86, 60, 133),
  Colors.deepPurpleAccent,
  Colors.deepPurpleAccent.shade700,
  Colors.black,
  Colors.grey.shade800,
);
final cherryBlossomThemeData = createLightThemeData(
  Colors.transparent,
  cherryBlossomGradient[3],
  cherryBlossomGradient[2],
  cherryBlossomGradient[2].withOpacity(0.5),
  cherryBlossomGradient[0],
  cherryBlossomGradient[0],
  cherryBlossomGradient[0].withOpacity(0.5),
);
