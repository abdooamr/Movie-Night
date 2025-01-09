import 'package:flutter/material.dart';

class PageTransitionBuilder {
  static void navigateWithCustomTransition(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(
            milliseconds: 500), // Adjust duration for a smoother transition
        pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve =
              Curves.easeInOutCubic; // Updated curve for smoother animation

          var slideTween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var scaleTween = Tween<double>(begin: 0.8, end: 1.0);

          return SlideTransition(
            position: animation.drive(slideTween),
            child: ScaleTransition(
              scale: animation.drive(scaleTween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
