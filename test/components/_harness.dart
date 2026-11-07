import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/app_theme.dart';

Widget harness(Widget child, {TextDirection? dir}) {
  Widget body = Scaffold(body: Center(child: child));
  if (dir != null) body = Directionality(textDirection: dir, child: body);
  return MaterialApp(
    theme: buildAppTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: body,
  );
}
