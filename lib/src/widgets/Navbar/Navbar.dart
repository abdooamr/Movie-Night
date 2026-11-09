import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/motion.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/navigation/routes.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:Movie_Night/src/services/app_update.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import 'chrome_bar.dart';

/// Old name kept so existing call sites (`auth.dart`) keep compiling.
typedef CustomBottomNavigationBar = AppShell;

/// The app shell: four fixed tabs (Home, Search, Library, Profile), each with
/// its own [Navigator] (spec section 6).
///
/// - Re-tapping the current tab pops it to its root; at the root it scrolls
///   the tab's primary scroll view to the top.
/// - System back pops the current tab's navigator first.
/// - Hidden tabs run with tickers off.
/// - The selected tab survives sign-in / sign-out.
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.isSignedIn,
    this.pagesBuilder,
  });

  final bool isSignedIn;

  /// Test hook replacing the four real (Firebase-backed) tab roots. Index 3 is
  /// the signed-in Profile page; signed out, the shell shows the
  /// [LoginWelcomeScreen] there regardless.
  @visibleForTesting
  final List<Widget> Function(bool signedIn)? pagesBuilder;

  static AppShellState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<AppShellState>();

  static AppShellState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'AppShell.of() called outside an AppShell');
    return state!;
  }

  @override
  State<AppShell> createState() => AppShellState();
}

class AppShellState extends State<AppShell> {
  static const int _tabCount = 4;
  static const int _libraryTab = 2;
  static const int _profileTab = 3;

  int _index = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    _tabCount,
    (i) => GlobalKey<NavigatorState>(debugLabel: 'tab$i'),
  );
  // Nested navigators need their own HeroController for Hero flights.
  final List<HeroController> _heroControllers = List.generate(
    _tabCount,
    (_) => MaterialApp.createMaterialHeroController(),
  );
  // The primary scroll controller of each tab's root route.
  final List<ScrollController> _scrollControllers =
      List.generate(_tabCount, (_) => ScrollController());

  /// Current tab roots. Rebuilt only when the sign-in state changes, so each
  /// root keeps its State (and scroll position) across tab switches.
  late final ValueNotifier<List<Widget>> _roots =
      ValueNotifier(_buildRoots(widget.isSignedIn));

  int get currentIndex => _index;

  List<Widget> _buildRoots(bool signedIn) {
    final pages = widget.pagesBuilder?.call(signedIn) ??
        [
          HomePage(),
          const ExplorePage(),
          LibraryPage(isSignedIn: signedIn),
          const SettingsScreen(),
        ];
    assert(pages.length == _tabCount);
    return [
      for (var i = 0; i < _tabCount; i++)
        if (i == _profileTab && !signedIn)
          const _SignedOutProfile()
        else
          pages[i],
    ];
  }

  @override
  void initState() {
    super.initState();
    // Needs a live Activity, so run after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => checkForForcedUpdate());
  }

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSignedIn == oldWidget.isSignedIn) return;
    _roots.value = _buildRoots(widget.isSignedIn);
    final signedIn = widget.isSignedIn;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Auth-dependent tabs start over from their root.
      for (final i in const [_libraryTab, _profileTab]) {
        _navigatorKeys[i].currentState?.popUntil((r) => r.isFirst);
      }
      if (signedIn) dismissSignIn();
    });
  }

  @override
  void dispose() {
    _roots.dispose();
    for (final c in _scrollControllers) {
      c.dispose();
    }
    for (final h in _heroControllers) {
      h.dispose();
    }
    super.dispose();
  }

  /// Switches to [index]; re-selecting the current tab pops it to its root,
  /// or scrolls to the top when it is already there.
  void selectTab(int index) {
    assert(index >= 0 && index < _tabCount);
    if (index != _index) {
      setState(() => _index = index);
      return;
    }
    final navigator = _navigatorKeys[index].currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.popUntil((r) => r.isFirst);
      return;
    }
    final scroll = _scrollControllers[index];
    if (!scroll.hasClients) return;
    final motion = MNMotion.of(context);
    if (motion.reduce) {
      scroll.jumpTo(0);
    } else {
      scroll.animateTo(
        0,
        duration: motion(MNDuration.medium),
        curve: MNCurves.standard,
      );
    }
  }

  Widget _tab(int i) {
    final current = i == _index;
    return TickerMode(
      enabled: current,
      child: NavigatorPopHandler<Object?>(
        enabled: current,
        // All four handlers sit on the same shell route, and the route calls
        // every one of them on a blocked pop (even disabled ones), so only
        // the current tab may act.
        onPopWithResult: (_) {
          if (i != _index) return;
          _navigatorKeys[i].currentState?.maybePop();
        },
        child: HeroControllerScope(
          controller: _heroControllers[i],
          child: Navigator(
            key: _navigatorKeys[i],
            onGenerateRoute: (settings) => MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => PrimaryScrollController(
                controller: _scrollControllers[i],
                child: ValueListenableBuilder<List<Widget>>(
                  valueListenable: _roots,
                  builder: (context, roots, _) => roots[i],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      extendBody: ChromeBar.floats(context),
      body: IndexedStack(
        index: _index,
        children: [for (var i = 0; i < _tabCount; i++) _tab(i)],
      ),
      bottomNavigationBar: ChromeBar(
        selectedIndex: _index,
        onDestinationSelected: selectTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(IconsaxOutline.home),
            selectedIcon: const Icon(IconsaxBold.home),
            label: s.homenavbar,
          ),
          NavigationDestination(
            icon: const Icon(IconsaxOutline.search_normal),
            selectedIcon: const Icon(IconsaxBold.search_normal),
            label: s.explorenavbar,
          ),
          NavigationDestination(
            icon: const Icon(IconsaxOutline.heart),
            selectedIcon: const Icon(IconsaxBold.heart),
            label: s.likednavbar,
          ),
          NavigationDestination(
            icon: const Icon(IconsaxOutline.user),
            selectedIcon: const Icon(IconsaxBold.user),
            label: s.profilenavbar,
          ),
        ],
      ),
    );
  }
}

/// Profile tab while signed out: the Log In / Create Account screen itself,
/// inline in the tab. Log In and Register push on the tab's navigator; the
/// shell pops back to the root once the user is signed in.
class _SignedOutProfile extends StatelessWidget {
  const _SignedOutProfile();

  @override
  Widget build(BuildContext context) => LoginWelcomeScreen(
        inSheet: false,
        title: S.of(context).profilenavbar,
      );
}
