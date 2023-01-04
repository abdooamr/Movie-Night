import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movietest1/Auth/auth.dart';
import 'package:movietest1/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie app',
      theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'poppins',
          iconTheme: const IconThemeData(color: Colors.white),
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
                  color: Colors.white)),
          scaffoldBackgroundColor: kBackgoundColor,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder()
          })),
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
