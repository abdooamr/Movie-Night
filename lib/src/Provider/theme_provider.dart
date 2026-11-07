import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User-selectable appearance. Defaults to following the system.
enum AppAppearance { system, dark, light }

class ThemeProvider extends ChangeNotifier {
  static const _appearanceKey = 'appearance';
  static const _legacyDarkModeKey = 'darkMode';

  AppAppearance appearance = AppAppearance.system;

  ThemeMode get themeMode => switch (appearance) {
        AppAppearance.system => ThemeMode.system,
        AppAppearance.dark => ThemeMode.dark,
        AppAppearance.light => ThemeMode.light,
      };

  /// Kept for legacy switch widgets; removed with them.
  bool get isDarkMode => appearance == AppAppearance.dark;

  ThemeProvider() {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_appearanceKey);
      AppAppearance? loaded;
      if (stored != null) {
        for (final a in AppAppearance.values) {
          if (a.name == stored) loaded = a;
        }
      } else {
        // One-time migration from the old bool switch.
        final legacy = prefs.getBool(_legacyDarkModeKey);
        if (legacy != null) {
          loaded = legacy ? AppAppearance.dark : AppAppearance.light;
          await prefs.setString(_appearanceKey, loaded.name);
          await prefs.remove(_legacyDarkModeKey);
        }
      }
      if (loaded != null && loaded != appearance) {
        appearance = loaded;
        notifyListeners();
      }
    } catch (_) {
      // Fall back to following the system.
    }
  }

  Future<void> setAppearance(AppAppearance a) async {
    appearance = a;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_appearanceKey, a.name);
    } catch (_) {}
  }

  @Deprecated('Use setAppearance; removed with the legacy switch widgets.')
  Future<void> toggleTheme(bool isOn) =>
      setAppearance(isOn ? AppAppearance.dark : AppAppearance.light);
}
