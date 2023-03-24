import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String? labelText;
  final bool obscureText;
  final IconData iconshape;
  final String? hinttext;

  const MyTextField(
      {super.key,
      this.hinttext,
      this.labelText,
      required this.controller,
      required this.obscureText,
      required this.iconshape});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            prefixIcon: Icon(
              iconshape,
              color: Colors.grey,
            ),
            fillColor: Color.fromARGB(255, 56, 48, 76),
            filled: true,
            labelText: labelText,
            hintText: hinttext,
            hintStyle: TextStyle(color: Colors.white),
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
