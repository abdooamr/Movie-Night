import 'package:Movie_Night/src/Provider/allproviders.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/Provider/reviewsprovider.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:Movie_Night/src/widgets/offline_banner.dart';
import 'package:Movie_Night/src/Auth/auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'src/design/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter<LikedModel>(LikedModelAdapter());
  await Hive.openBox<LikedModel>('liked');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ReviewProvider()),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => UserData()),
    ChangeNotifierProvider(create: (context) => DropdownProvider()),
  ], child: const MyApp()));
}

final _lightTheme = buildAppTheme(Brightness.light);
final _darkTheme = buildAppTheme(Brightness.dark);
final _lightHighContrastTheme =
    buildAppTheme(Brightness.light, highContrast: true);
final _darkHighContrastTheme =
    buildAppTheme(Brightness.dark, highContrast: true);

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Consumer<DropdownProvider>(
        builder: (context, dropdownProvider, child) {
      return MaterialApp(
        title: 'Movie Night',
        theme: _lightTheme,
        darkTheme: _darkTheme,
        highContrastTheme: _lightHighContrastTheme,
        highContrastDarkTheme: _darkHighContrastTheme,
        themeMode: themeProvider.themeMode,
        debugShowCheckedModeBanner: false,
        locale: Locale(dropdownProvider.selectedValue),
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        builder: (context, child) => OfflineBanner(
            child: applyAccessibilityTheme(
                context, child ?? const SizedBox.shrink())),
        home: AuthPage(),
      );
    });
  }
}
