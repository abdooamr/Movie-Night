import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropdownProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  String _selectedValue = 'en';

  DropdownProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    final devicelocal = await Devicelocale.currentLocale;
    String firstTwoLetters = devicelocal!.substring(0, 2);

    // List of valid language codes
    List<String> validLanguages = ['ar', 'de', 'en', 'es', 'fr', 'hi', 'it'];

    // If the device language is not in the validLanguages list, set it to 'en'
    if (!validLanguages.contains(firstTwoLetters)) {
      firstTwoLetters = 'en';
    }

    _prefs = await SharedPreferences.getInstance();
    _selectedValue = _prefs.getString('selectedValue') ?? firstTwoLetters;
    notifyListeners();
  }

  String get selectedValue => _selectedValue;

  Future<void> setSelectedValue(String value) async {
    _selectedValue = value;
    await _prefs.setString('selectedValue', value);
    notifyListeners();
  }
}
