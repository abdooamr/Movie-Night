import 'package:flutter/material.dart';

class customtextbutton extends StatelessWidget {
  final String Texts;
  final double textsize;
  final dynamic onpressed;

  const customtextbutton({
    super.key,
    required this.Texts,
    required this.textsize,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onpressed;
        },
        child: Text(
          Texts,
          style: TextStyle(
            fontFamily: 'Pacifico',
            color: Colors.red,
            fontSize: textsize,
          ),
        ));
  }
}
