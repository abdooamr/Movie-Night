import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class textcustom extends StatelessWidget {
  final String Texts;

  const textcustom({
    super.key,
    required this.Texts,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      Texts,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
