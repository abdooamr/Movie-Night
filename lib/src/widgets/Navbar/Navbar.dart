import 'dart:ui';
import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final bool isSignedIn;

  CustomBottomNavigationBar({Key? key, required this.isSignedIn})
      : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int currentIndex = 0;

  @override
  void didUpdateWidget(CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Set currentIndex to 0 only when widget.isSignedIn changes from false to true
    if (widget.isSignedIn && !oldWidget.isSignedIn) {
      setState(() {
        currentIndex = 0;
      });
    }
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List pages = widget.isSignedIn
        ? [
            HomePage(),
            const ExplorePage(),
            const Liked(),
            const settings_screen()
          ]
        : [HomePage(), const ExplorePage(), const loWelcomeScreen()];

    // Reset currentIndex if it's out of range
    if (currentIndex >= pages.length) {
      currentIndex = 0;
    }

    return Scaffold(
      body: pages[currentIndex],
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Consumer<DropdownProvider>(
                builder: (context, dropdownProvider, _) {
              return BottomNavigationBar(
                currentIndex: currentIndex,
                backgroundColor: Colors.black.withOpacity(.1),
                type: BottomNavigationBarType.fixed,
                onTap: onTap,
                selectedItemColor: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
                unselectedItemColor: Colors.grey.shade500,
                elevation: 0,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedFontSize: 10,
                unselectedFontSize: 10,
                items: widget.isSignedIn
                    ? [
                        BottomNavigationBarItem(
                            icon: Icon(IconsaxOutline.home),
                            activeIcon: Icon(IconsaxBold.home),
                            label: S.of(context).homenavbar),
                        BottomNavigationBarItem(
                            icon: Icon(IconsaxOutline.search_normal),
                            activeIcon: Icon(IconsaxBold.search_normal),
                            label: S.of(context).explorenavbar),
                        BottomNavigationBarItem(
                            icon: Icon(IconsaxOutline.heart),
                            activeIcon: Icon(IconsaxBold.heart),
                            label: S.of(context).likednavbar),
                        BottomNavigationBarItem(
                            icon: Icon(IconsaxOutline.user),
                            activeIcon: Icon(IconsaxBold.user),
                            label: S.of(context).profilenavbar),
                      ]
                    : [
                        BottomNavigationBarItem(
                            icon: Icon(IconsaxOutline.home),
                            activeIcon: Icon(IconsaxBold.home),
                            label: S.of(context).homenavbar),
                        BottomNavigationBarItem(
                            icon: Icon(IconsaxOutline.search_normal),
                            activeIcon: Icon(IconsaxBold.search_normal),
                            label: S.of(context).explorenavbar),
                        BottomNavigationBarItem(
                            icon: Icon(IconsaxOutline.user),
                            activeIcon: Icon(IconsaxBold.user),
                            label: S.of(context).loginbuttonlabel),
                      ],
              );
            })),
      ),
    );
  }
}
