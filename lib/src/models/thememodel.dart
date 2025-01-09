import 'package:Movie_Night/src/Provider/Theme_Data.dart';
import 'package:Movie_Night/src/components/colorpalette.dart';
import 'package:flutter/material.dart';

class ThemeModel {
  final int index;
  final List<Color> colors;
  final ThemeData themeData;

  ThemeModel({
    required this.index,
    required this.colors,
    required this.themeData,
  });
}

List<ThemeModel> themeModels = [
  ThemeModel(index: 0, colors: lightThemeGradient, themeData: lightThemeData),
  ThemeModel(index: 1, colors: darkThemeGradient, themeData: darkThemeData),
  ThemeModel(
      index: 2, colors: oceanicWavesGradient, themeData: oceanicWavesThemeData),
  ThemeModel(
      index: 3,
      colors: elegantNeutralsGradient,
      themeData: elegantNeutralsThemeData),
  ThemeModel(
      index: 4,
      colors: mysticMeadowsGradient,
      themeData: mysticMeadowsThemeData),
  ThemeModel(
      index: 5, colors: cottonCandyGradient, themeData: cottonCandyThemeData),
  ThemeModel(
      index: 6,
      colors: cherryBlossomGradient,
      themeData: cherryBlossomThemeData),
  ThemeModel(
      index: 7,
      colors: luminousGalaxyGradient,
      themeData: luminousGalaxyThemeData),
];
