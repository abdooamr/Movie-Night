import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../pages/Login-Logout/Login_welcome_screen.dart';
import '../pages/UI/detail_page.dart';
import '../pages/UI/showallmovies.dart';

/// Test hook: when set, [openTitle] pushes this instead of [DetailPage]
/// (which needs Firebase). Reset to null in `tearDown`.
@visibleForTesting
Widget Function(int id, bool isTv, String? heroTag)? debugDetailPageBuilder;

/// Pushes the title's detail page on the **current tab's** navigator, so the
/// tab bar stays visible and re-tapping the tab pops back.
Future<void> openTitle(
  BuildContext context, {
  required int id,
  required bool isTv,
  String? heroTag,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) =>
          debugDetailPageBuilder?.call(id, isTv, heroTag) ??
          DetailPage(id: id, isTvShow: isTv, heroTag: heroTag),
    ),
  );
}

/// Pushes the "See All" grid for a rail on the current tab's navigator.
/// [load] is called once, here; the existing page takes the resulting Future.
Future<void> openSeeAll(
  BuildContext context, {
  required String title,
  required Future<Model> Function() load,
  required bool isTv,
}) {
  final future = load();
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) =>
          See_All(future: future, headlineText: title, istvshow: isTv),
    ),
  );
}

Route<void>? _signInRoute;

/// Presents the sign-in flow modally on the **root** navigator, above the
/// tab bar. The shell dismisses it once the user is signed in. A no-op while
/// the sheet is already up, so a double tap never stacks two sheets.
Future<void> presentSignIn(BuildContext context) {
  if (_signInRoute?.isActive ?? false) return Future<void>.value();
  final route = MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (_) => const _SignInSheet(),
  );
  _signInRoute = route;
  return Navigator.of(context, rootNavigator: true)
      .push<void>(route)
      .whenComplete(() {
    if (identical(_signInRoute, route)) _signInRoute = null;
  });
}

/// Closes the sheet opened by [presentSignIn], if it is still up. Routes the
/// log-in pages pushed above it are left for them to pop themselves.
void dismissSignIn() {
  final route = _signInRoute;
  _signInRoute = null;
  final navigator = route?.navigator;
  if (route == null || navigator == null || !route.isActive) return;
  if (route.isCurrent) {
    navigator.pop();
  } else {
    navigator.removeRoute(route);
  }
}

/// [LoginWelcomeScreen] has no way out of its own; add a Close button.
class _SignInSheet extends StatelessWidget {
  const _SignInSheet();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const LoginWelcomeScreen(),
        PositionedDirectional(
          top: 0,
          end: 0,
          child: SafeArea(
            child: Material(
              type: MaterialType.transparency,
              child: CloseButton(
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
