import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      style: GoogleFonts.pacifico(
          color: Colors.white,
          fontWeight: weight,
          //fontWeight: FontWeight.bold,
          fontSize: textsize),
    );
  }
}
