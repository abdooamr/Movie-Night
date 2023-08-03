// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:Movie_Night/src/pages/Userpage/Settings_screen.dart';
// import 'package:Movie_Night/src/pages/UI/explore.dart';
// import 'package:Movie_Night/src/pages/UI/home_page.dart';
// import 'package:Movie_Night/src/pages/UI/liked.dart';
// import 'package:ficonsax/ficonsax.dart';

// class loggedmainpage extends StatefulWidget {
//   const loggedmainpage({Key? key}) : super(key: key);

//   @override
//   State<loggedmainpage> createState() => _loggedmainpageState();
// }

// class _loggedmainpageState extends State<loggedmainpage> {
//   List pages = [
//     HomePage(),
//     const ExplorePage(),
//     const Liked(),
//     const settings_screen(),
//   ];
//   int currentIndex = 0;
//   void onTap(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[currentIndex],
//       extendBody: true,
//       bottomNavigationBar: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
//           child: BottomNavigationBar(
//               currentIndex: currentIndex,
//               backgroundColor: Colors.black.withOpacity(.1),
//               type: BottomNavigationBarType.fixed,
//               onTap: onTap,
//               selectedItemColor: Colors.white,
//               unselectedItemColor: Colors.grey.shade500,
//               elevation: 0,
//               showSelectedLabels: false,
//               showUnselectedLabels: false,
//               selectedFontSize: 0,
//               items: const [
//                 BottomNavigationBarItem(
//                     icon: Icon(IconsaxOutline.home),
//                     activeIcon: Icon(IconsaxBold.home),
//                     label: 'Home'),
//                 BottomNavigationBarItem(
//                     icon: Icon(IconsaxOutline.search_normal),
//                     activeIcon: Icon(IconsaxBold.search_normal),
//                     label: 'Explore'),
//                 BottomNavigationBarItem(
//                     icon: Icon(IconsaxOutline.heart),
//                     activeIcon: Icon(IconsaxBold.heart),
//                     label: 'Liked'),
//                 BottomNavigationBarItem(
//                     icon: Icon(IconsaxOutline.user),
//                     activeIcon: Icon(IconsaxBold.user),
//                     label: 'Login'),
//               ]),
//         ),
//       ),
//     );
//   }
// }
