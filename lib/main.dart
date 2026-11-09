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
import 'src/data/supabase_config.dart';
import 'src/design/performance.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const bool _forceLowPower = bool.fromEnvironment('FORCE_LOW_POWER');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase stays for Cloud Messaging only; auth and data are Supabase.
  await Firebase.initializeApp();
  assert(
    SupabaseConfig.anonKey.isNotEmpty,
    'SUPABASE_ANON_KEY is missing: run with --dart-define-from-file=env.json',
  );
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );
  await Hive.initFlutter();
  Hive.registerAdapter<LikedModel>(LikedModelAdapter());
  await Hive.openBox<LikedModel>('liked');

  // Watches frame timings; drops decorative motion on devices that can't
  // keep up (see PerformanceMonitor). `--dart-define=FORCE_LOW_POWER=true`
  // starts in low power, for testing and benchmarks.
  final performance = PerformanceMonitor(
    debugForceLowPower: _forceLowPower ? true : null,
  )..start();

  runApp(PerformanceScope(
    notifier: performance,
    child: MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ReviewProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => UserData()),
      ChangeNotifierProvider(create: (context) => DropdownProvider()),
    ], child: const MyApp()),
  ));
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
