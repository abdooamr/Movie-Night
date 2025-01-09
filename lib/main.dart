import 'package:Movie_Night/src/Provider/allproviders.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/Provider/newthemeprovider.dart';
import 'package:Movie_Night/src/Provider/reviewsprovider.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/models/thememodel.dart';
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

  final colorProvider = ColorProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: colorProvider),
        ChangeNotifierProvider(create: (context) => ReviewProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UserData()),
        ChangeNotifierProvider(
          create: (context) => DropdownProvider(),
          child: MyApp(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  Future<bool> _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  ThemeData getThemeData(int index) {
    return themeModels[index].themeData;
  }

  @override
  Widget build(BuildContext context) {
    final colorprovider = Provider.of<ColorProvider>(context);
    final dropdownProvider = Provider.of<DropdownProvider>(context);
    ThemeData selectedTheme = getThemeData(colorprovider.currentIndex);
    print("INDEXX:{${colorprovider.currentIndex}}");
    print("THEEEMEEE:{${selectedTheme}}");
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colorprovider.selectedColors.isEmpty
              ? themeModels[colorprovider.currentIndex].colors
              : colorprovider.selectedColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: MaterialApp(
        title: 'Movie Night',
        theme: selectedTheme,
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
                color: Theme.of(context).splashColor,
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
