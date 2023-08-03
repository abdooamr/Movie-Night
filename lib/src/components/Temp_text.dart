import 'dart:async';
import 'package:flutter/material.dart';

class TemporaryText extends StatefulWidget {
  final String text;

  TemporaryText({required this.text});

  @override
  _TemporaryTextState createState() => _TemporaryTextState();
}

class _TemporaryTextState extends State<TemporaryText> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: Text(
        widget.text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
