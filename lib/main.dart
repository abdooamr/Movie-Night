import 'package:Movie_Night/src/Provider/allproviders.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/Provider/reviewsprovider.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:Movie_Night/src/components/alertdialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:Movie_Night/src/Auth/auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'generated/l10n.dart';

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
    ChangeNotifierProvider(
      create: (context) => DropdownProvider(),
      child: MyApp(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  Future<bool> _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Consumer<DropdownProvider>(
            builder: (context, dropdownProvider, child) {
          return MaterialApp(
            title: 'Movie app',
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
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
            home: FutureBuilder<bool>(
              future: _checkInternetConnectivity(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,
                    strokeWidth: 3,
                  );
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
        });
      },
    );
  }

  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing by tapping outside of the dialog
      builder: (context) {
        return CustomDialog(
          title: S.of(context).noInternet,
          content: S.of(context).pleasecheckinternetconnection,
          onOkPressed: () {
            Fluttertoast.showToast(msg: 'Terminating App');
            SystemNavigator.pop(); // Terminate the app
          },
        );
      },
    );
  }
}
