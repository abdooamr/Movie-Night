import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/newthemeprovider.dart';
import 'package:Movie_Night/src/models/thememodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeList extends StatefulWidget {
  @override
  _ThemeListState createState() => _ThemeListState();
}

class _ThemeListState extends State<ThemeList> {
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    setState(() {
      _isFirstTime = isFirstTime;
    });

    if (isFirstTime) {
      prefs.setBool('isFirstTime', false);
    }
  }

  void _onColorSelected(List<Color> selectedColors, int index) {
    Provider.of<ColorProvider>(context, listen: false)
        .setSelectedColors(selectedColors, index);
  }

  bool _isNewTheme(int index) {
    List<int> newThemeIndices = [6, 7, 4, 5, 2, 3];
    return newThemeIndices.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge!,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyLarge!.color),
        title: Text(S.of(context).themelabel),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildThemeRow([themeModels[0].colors, themeModels[1].colors], 0),
          _buildThemeRow([themeModels[2].colors, themeModels[3].colors], 1),
          _buildThemeRow([themeModels[4].colors, themeModels[5].colors], 2),
          _buildThemeRow([themeModels[6].colors, themeModels[7].colors], 3),
          SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeRow(List<List<Color>> colors, int rowIndex) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: colors
              .asMap()
              .entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      _buildColoredContainer(entry.value, rowIndex, entry.key),
                      if (_isNewTheme(rowIndex * 2 + entry.key) && _isFirstTime)
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 0, 255, 187), // Change to gold color
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Text(
                              S.of(context).New,
                              style: TextStyle(
                                color:
                                    Colors.black, // Change to suit your design
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: colors
              .asMap()
              .entries
              .map(
                (entry) => Text(
                  _getThemeTitle(rowIndex * 2 + entry.key),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildColoredContainer(
      List<Color> colors, int rowIndex, int colIndex) {
    bool isSelected = Provider.of<ColorProvider>(context).currentIndex ==
        rowIndex * 2 + colIndex;

    return GestureDetector(
      onTap: () {
        _onColorSelected(colors, rowIndex * 2 + colIndex);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Color.fromARGB(255, 0, 255, 187)
                  : Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: isSelected
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }

  String _getThemeTitle(int index) {
    switch (index) {
      case 0:
        return S.of(context).LightTheme;
      case 1:
        return S.of(context).DarkTheme;
      case 2:
        return S.of(context).OceanicWaves;
      case 3:
        return S.of(context).ElegantNeutrals;
      case 4:
        return S.of(context).mysticMeadows;
      case 5:
        return S.of(context).CottonCandy;
      case 6:
        return S.of(context).CherryBlossom;
      case 7:
        return S.of(context).LuminousGalaxy;
      default:
        return 'Unknown Theme';
    }
  }
}
