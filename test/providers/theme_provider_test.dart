import 'package:Movie_Night/src/Provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> settle() => pumpEventQueue();

  test('defaults to system when nothing is stored', () async {
    SharedPreferences.setMockInitialValues({});
    final p = ThemeProvider();
    await settle();
    expect(p.appearance, AppAppearance.system);
    expect(p.themeMode, ThemeMode.system);
  });

  test('migrates legacy darkMode=false to light and removes the old key',
      () async {
    SharedPreferences.setMockInitialValues({'darkMode': false});
    final p = ThemeProvider();
    await settle();
    expect(p.appearance, AppAppearance.light);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey('darkMode'), isFalse);
    expect(prefs.getString('appearance'), 'light');
  });

  test('migrates legacy darkMode=true to dark', () async {
    SharedPreferences.setMockInitialValues({'darkMode': true});
    final p = ThemeProvider();
    await settle();
    expect(p.appearance, AppAppearance.dark);
    expect(p.themeMode, ThemeMode.dark);
  });

  test('setAppearance notifies once and persists the name', () async {
    SharedPreferences.setMockInitialValues({});
    final p = ThemeProvider();
    await settle();
    var notified = 0;
    p.addListener(() => notified++);

    await p.setAppearance(AppAppearance.dark);
    expect(p.appearance, AppAppearance.dark);
    expect(notified, 1);
    expect((await SharedPreferences.getInstance()).getString('appearance'),
        'dark');
  });

  test('persisted choice survives a new provider instance', () async {
    SharedPreferences.setMockInitialValues({});
    await ThemeProvider().setAppearance(AppAppearance.light);
    final fresh = ThemeProvider();
    await settle();
    expect(fresh.appearance, AppAppearance.light);
  });

  test('themeMode maps each appearance', () async {
    SharedPreferences.setMockInitialValues({});
    final p = ThemeProvider();
    await settle();
    await p.setAppearance(AppAppearance.system);
    expect(p.themeMode, ThemeMode.system);
    await p.setAppearance(AppAppearance.dark);
    expect(p.themeMode, ThemeMode.dark);
    await p.setAppearance(AppAppearance.light);
    expect(p.themeMode, ThemeMode.light);
  });

  test('deprecated toggleTheme maps to dark/light', () async {
    SharedPreferences.setMockInitialValues({});
    final p = ThemeProvider();
    await settle();
    // ignore: deprecated_member_use_from_same_package
    await p.toggleTheme(true);
    expect(p.appearance, AppAppearance.dark);
    expect(p.isDarkMode, isTrue);
    // ignore: deprecated_member_use_from_same_package
    await p.toggleTheme(false);
    expect(p.appearance, AppAppearance.light);
    expect(p.isDarkMode, isFalse);
  });
}
