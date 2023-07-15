import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/services/push_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:Movie_Night/src/Auth/auth.dart';
import 'package:Movie_Night/src/Provider/Theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'src/pages/Adminpages/details category.dart';
import 'src/pages/Adminpages/fulldetails.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter<LikedModel>(LikedModelAdapter());
  await Hive.openBox<LikedModel>('liked');
  await Settings.init(cacheProvider: SharePreferenceCache());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'Movie app',
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: AuthPage(),
        );
      },
    );
  }
}
