import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/widgets/Navbar/Navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Wraps [AppShell] in a themed, localised [MaterialApp] (no Firebase).
Widget shellApp({
  required bool isSignedIn,
  required List<Widget> Function(bool signedIn) pagesBuilder,
}) =>
    MaterialApp(
      theme: buildAppTheme(Brightness.dark),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: AppShell(isSignedIn: isSignedIn, pagesBuilder: pagesBuilder),
    );
