import 'dart:io';
import 'dart:typed_data';

import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/Provider/theme_provider.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/pages/Login-Logout/Login.dart';
import 'package:Movie_Night/src/pages/Login-Logout/Register.dart';
import 'package:Movie_Night/src/pages/UI/library_page.dart';
import 'package:Movie_Night/src/pages/UI/liked.dart';
import 'package:Movie_Night/src/pages/Userpage/signed_out_profile.dart';
import 'package:Movie_Night/src/widgets/themechanger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/_harness.dart';

const _localeChannel = MethodChannel('uk.spiralarm.flutter/devicelocale');

Widget _app(Widget page, {double textScale = 1}) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DropdownProvider()),
      ],
      child: harness(Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: page,
        ),
      )),
    );

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  late Directory dir;
  setUpAll(() async {
    dir = Directory.systemTemp.createTempSync('signed_out_test');
    Hive.init(dir.path);
    Hive.registerAdapter(LikedModelAdapter());
    await Hive.openBox<LikedModel>('liked', bytes: Uint8List(0));
  });
  tearDownAll(() async {
    await Hive.close();
    try {
      dir.deleteSync(recursive: true);
    } catch (_) {}
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localeChannel, (_) async => 'en_US');
  });

  group('Profile, signed out', () {
    testWidgets('log-in card, then settings that need no account',
        (tester) async {
      _phone(tester);
      await tester.pumpWidget(_app(const SignedOutProfile()));
      await tester.pump();

      expect(find.text('Log In to Movie Night'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Log In'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Create Account'),
          findsOneWidget);
      expect(find.byType(AppearanceSetting), findsOneWidget);
      expect(find.text('Change Language'), findsOneWidget);
      expect(find.text('Rate Movie Night'), findsOneWidget);
      // Account-only rows are not offered.
      expect(find.text('Log Out'), findsNothing);
      expect(find.text('Delete Account'), findsNothing);
    });

    testWidgets('Log In and Create Account open inside the tab',
        (tester) async {
      _phone(tester);
      await tester.pumpWidget(_app(const SignedOutProfile()));
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Log In'));
      await tester.pumpAndSettle();
      expect(find.byType(Login), findsOneWidget);
      Navigator.of(tester.element(find.byType(Login))).pop();
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(OutlinedButton, 'Create Account'));
      await tester.pumpAndSettle();
      expect(find.byType(Register), findsOneWidget);
    });

    testWidgets('no overflow at 2x text', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_app(const SignedOutProfile(), textScale: 2));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('Library, signed out', () {
    testWidgets('Liked works without an account', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_app(const LibraryPage(isSignedIn: false)));
      await tester.pump();

      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.byType(LikedView), findsOneWidget);
      expect(find.text('Log In to Use Your Watchlist'), findsNothing);
    });

    testWidgets('Watchlist explains why it needs an account and offers Log In',
        (tester) async {
      _phone(tester);
      await tester.pumpWidget(_app(const LibraryPage(isSignedIn: false)));
      await tester.pump();

      await tester.tap(find.text('Watchlist'));
      await tester.pumpAndSettle();
      expect(find.text('Log In to Use Your Watchlist'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Log In'), findsOneWidget);
      expect(find.byType(LikedView), findsNothing);
    });
  });
}
