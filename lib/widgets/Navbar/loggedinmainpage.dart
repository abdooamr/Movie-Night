import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movietest1/pages/Userpage/UserPage.dart';
import 'package:movietest1/pages/explore.dart';
import 'package:movietest1/pages/home_page.dart';
import 'package:movietest1/pages/liked.dart';

class loggedmainpage extends StatefulWidget {
  const loggedmainpage({Key? key}) : super(key: key);

  @override
  State<loggedmainpage> createState() => _loggedmainpageState();
}

class _loggedmainpageState extends State<loggedmainpage> {
  List pages = [
    const HomePage(),
    const ExplorePage(),
    const Liked(),
    const Userpage(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: BottomNavigationBar(
              currentIndex: currentIndex,
              backgroundColor: Colors.black.withOpacity(.1),
              type: BottomNavigationBarType.fixed,
              onTap: onTap,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey.shade500,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedFontSize: 0,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    activeIcon: Icon(Icons.explore_rounded),
                    label: 'Explore'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    activeIcon: Icon(Icons.favorite),
                    label: 'Liked'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    activeIcon: Icon(Icons.person),
                    label: 'Login'),
              ]),
        ),
      ),
    );
  }
}
