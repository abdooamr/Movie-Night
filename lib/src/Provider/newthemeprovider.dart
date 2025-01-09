import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorProvider with ChangeNotifier {
  List<Color> _selectedColors = [];
  int _currentIndex = 1; // Default value indicating no selection
  static const String _colorsKey = 'selected_colors';
  static const String _currentIndexKey = 'current_index'; // Added key for index

  ColorProvider() {
    // Load selected colors and current index from SharedPreferences
    _loadSelectedColors();
    _loadCurrentIndex();
  }

  List<Color> get selectedColors => _selectedColors;
  int get currentIndex => _currentIndex;

  void setSelectedColors(List<Color> colors, int index) {
    _selectedColors = colors;
    _currentIndex = index; // Update the current index
    _saveSelectedColors();
    _saveCurrentIndex(); // Save the current index
    notifyListeners();
  }

  Future<void> _loadSelectedColors() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_colorsKey)) {
      final List<String> colorStrings = prefs.getStringList(_colorsKey) ?? [];
      _selectedColors = colorStrings.map((colorString) {
        final List<String> components = colorString.split(',');
        return Color.fromRGBO(
          int.parse(components[0]),
          int.parse(components[1]),
          int.parse(components[2]),
          double.parse(components[3]),
        );
      }).toList();
    }
  }

  Future<void> _saveSelectedColors() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> colorStrings = _selectedColors
        .map((color) =>
            '${color.red},${color.green},${color.blue},${color.opacity}')
        .toList();
    prefs.setStringList(_colorsKey, colorStrings);
  }

  Future<void> _loadCurrentIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_currentIndexKey)) {
      _currentIndex = prefs.getInt(_currentIndexKey) ?? -1;
    }
  }

  Future<void> _saveCurrentIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_currentIndexKey, _currentIndex);
  }
}
