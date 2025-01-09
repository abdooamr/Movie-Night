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
          return widget.validation == null
              ? null
              : (value!.isEmpty || !RegExp(widget.validation!).hasMatch(value))
                  ? widget.valitext
                  : null;
        },
        style: TextStyle(color: Colors.white),
        focusNode: _focusNode,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.iconshape,
            color: Colors.grey,
          ),
          filled: true,
          fillColor: Colors.transparent,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Theme.of(context).hintColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
                color: hasFocus
                    ? Theme.of(context).splashColor
                    : Colors.transparent),
          ),
        ),
      ),
    );
  }
}
