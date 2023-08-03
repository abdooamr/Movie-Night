import 'package:Movie_Night/src/components/alertdialog.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:Movie_Night/src/Auth/auth.dart';
import 'package:Movie_Night/src/Provider/Theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Future<bool> _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Movie Night',
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: FutureBuilder<bool>(
              future: _checkInternetConnectivity(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.data == true) {
                  return AuthPage();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showNoInternetDialog(context);
                  });
                  return SizedBox.shrink();
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing by tapping outside of the dialog
      builder: (context) {
        return CustomDialog(
          title: 'No Internet Connection',
          content: 'Please check your internet connection and try again.',
          onOkPressed: () {
            Fluttertoast.showToast(msg: 'Terminating App');
            SystemNavigator.pop(); // Terminate the app
          },
        );
      },
    );
  }
}
