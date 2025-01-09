import 'package:flutter/material.dart';

class customtext extends StatelessWidget {
  final String Texts;
  final double textsize;
  final FontWeight? weight;

  const customtext(
      {super.key, required this.Texts, required this.textsize, this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(
      Texts,
      style: TextStyle(
          fontFamily: 'Pacifico',
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: weight,
          //fontWeight: FontWeight.bold,
          fontSize: textsize),
    );
  }
}
