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
  late Timer _timer; // Declare the Timer variable

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
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
