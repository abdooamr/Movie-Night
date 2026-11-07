import 'package:Movie_Night/src/Provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('defaults to dark when nothing is stored', () async {
    SharedPreferences.setMockInitialValues({});
    final p = ThemeProvider();
    await settle();
    expect(p.themeMode, ThemeMode.dark);
    expect(p.isDarkMode, isTrue);
  });

  test('loads stored light preference', () async {
    SharedPreferences.setMockInitialValues({'darkMode': false});
    final p = ThemeProvider();
    await settle();
    expect(p.themeMode, ThemeMode.light);
    expect(p.isDarkMode, isFalse);
  });

  test('toggleTheme updates mode, notifies and persists', () async {
    SharedPreferences.setMockInitialValues({});
    final p = ThemeProvider();
    await settle();
    var notified = 0;
    p.addListener(() => notified++);

    await p.toggleTheme(false);
    expect(p.themeMode, ThemeMode.light);
    expect(notified, 1);
    expect((await SharedPreferences.getInstance()).getBool('darkMode'), false);

    await p.toggleTheme(true);
    expect(p.themeMode, ThemeMode.dark);
    expect((await SharedPreferences.getInstance()).getBool('darkMode'), true);
  });

  test('persisted choice survives a new provider instance', () async {
    SharedPreferences.setMockInitialValues({});
    await ThemeProvider().toggleTheme(false);
    final fresh = ThemeProvider();
    await settle();
    expect(fresh.themeMode, ThemeMode.light);
  });

  test('themes have matching brightness', () {
    expect(MyThemes.darkTheme.brightness, Brightness.dark);
    expect(MyThemes.lightTheme.brightness, Brightness.light);
  });
}
