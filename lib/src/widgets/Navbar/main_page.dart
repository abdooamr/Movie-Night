import 'dart:ui';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/pages/UI/explore.dart';
import 'package:Movie_Night/src/pages/UI/home_page.dart';
import '../../pages/Login-Logout/Login_welcome_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    HomePage(),
    const ExplorePage(),
    const loWelcomeScreen(),
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
                    icon: Icon(IconsaxOutline.home),
                    activeIcon: Icon(IconsaxBold.home),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(IconsaxOutline.search_normal),
                    activeIcon: Icon(IconsaxBold.search_normal),
                    label: 'Explore'),
                BottomNavigationBarItem(
                    icon: Icon(IconsaxOutline.user),
                    activeIcon: Icon(IconsaxBold.user),
                    label: 'Login'),
              ]),
        ),
      ),
    );
  }
}
