import 'package:Movie_Night/src/Provider/newthemeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final colorprovider = Provider.of<ColorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.titleLarge!,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyLarge!.color),
        title: Text(title),
        backgroundColor: colorprovider.selectedColors[1],
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
