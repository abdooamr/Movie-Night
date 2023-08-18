import 'package:Movie_Night/src/utils/utils.dart';
import 'package:flutter/material.dart';

class Settings_Screen extends StatelessWidget {
  /// Appbar title in Scaffold.
  final String title;

  /// Content of the screen, body of the Scaffold.
  final List<Widget> children;

  Settings_Screen({
    required this.children,
    this.title = 'Settings',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kBackgoundColor,
        shadowColor: Colors.transparent,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          return children[index];
        },
      ),
    );
  }
}
