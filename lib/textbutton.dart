import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          style: GoogleFonts.pacifico(
            color: Colors.red,
            fontSize: textsize,
          ),
        ));
  }
}
