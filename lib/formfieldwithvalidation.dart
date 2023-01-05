import 'package:flutter/material.dart';

class Customvalformfield extends StatelessWidget {
  final controller;
  final String labelText;
  final bool obscureText;
  final String validation;
  final IconData iconshape;

  const Customvalformfield(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.obscureText,
      required this.validation,
      required this.iconshape});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value!.isEmpty || !RegExp(validation).hasMatch(value)) {
            return "Enter Correct " + labelText;
          } else
            return null;
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            prefixIcon: Icon(
              iconshape,
              color: Colors.grey,
            ),
            fillColor: Color.fromARGB(255, 56, 48, 76),
            filled: true,
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            )),
      ),
    );
  }
}
