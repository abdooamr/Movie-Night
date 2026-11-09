import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/widgets/Navbar/Navbar.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/Provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Wraps [AppShell] in a themed, localised [MaterialApp] (no Firebase), with
/// the providers the signed-out Profile tab's settings read.
Widget shellApp({
  required bool isSignedIn,
  required List<Widget> Function(bool signedIn) pagesBuilder,
}) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DropdownProvider()),
      ],
      child: MaterialApp(
        theme: buildAppTheme(Brightness.dark),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
        home: AppShell(isSignedIn: isSignedIn, pagesBuilder: pagesBuilder),
      ),
    );
