import 'package:flutter/material.dart';

class Customvalformfield extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final String? validation;
  final IconData iconshape;
  final String? valitext;

  const Customvalformfield({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.obscureText,
    this.validation,
    this.valitext,
    required this.iconshape,
  }) : super(key: key);

  @override
  _CustomvalformfieldState createState() => _CustomvalformfieldState();
}

class _CustomvalformfieldState extends State<Customvalformfield> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      // Just update the FocusNode without setting a new value for _hasFocus
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasFocus = _focusNode.hasFocus;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        validator: (value) {
          if (value!.isEmpty || !RegExp(widget.validation!).hasMatch(value)) {
            return widget.valitext;
          } else
            return null;
        },
        style: TextStyle(color: Colors.white),
        focusNode: _focusNode,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.iconshape,
            color: Colors.grey,
          ),
          filled: true,
          fillColor:
              hasFocus ? Color.fromARGB(255, 56, 48, 76) : Colors.transparent,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide(color: hasFocus ? Colors.grey : Colors.transparent),
          ),
        ),
      ),
    );
  }
}
