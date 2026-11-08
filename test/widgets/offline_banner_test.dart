import 'dart:async';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/widgets/offline_banner.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Stream<List<ConnectivityResult>> stream, {Widget? body}) =>
    MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: OfflineBanner(
        connectivityStream: stream,
        child: body ?? const Scaffold(body: Text('content')),
      ),
    );

void main() {
  testWidgets('banner is hidden online, a live region when offline',
      (tester) async {
    final handle = tester.ensureSemantics();
    final ctrl = StreamController<List<ConnectivityResult>>();
    addTearDown(ctrl.close);
    await tester.pumpWidget(_app(ctrl.stream));
    await tester.pumpAndSettle();
    final msg = (await S.delegate.load(const Locale('en'))).noInternet;
    expect(find.text(msg), findsNothing);

    ctrl.add([ConnectivityResult.none]);
    await tester.pumpAndSettle();
    expect(find.text(msg), findsOneWidget);
    final node = tester.getSemantics(find.text(msg));
    // ignore: deprecated_member_use
    expect(node.hasFlag(SemanticsFlag.isLiveRegion), isTrue);
    expect(find.text('content'), findsOneWidget);

    ctrl.add([ConnectivityResult.wifi]);
    await tester.pumpAndSettle();
    expect(find.text(msg), findsNothing);
    handle.dispose();
  });

  testWidgets(
      'app bar and back button lay out below the banner and stay '
      'tappable while offline', (tester) async {
    final ctrl = StreamController<List<ConnectivityResult>>();
    addTearDown(ctrl.close);
    var popped = false;
    await tester.pumpWidget(_app(
      ctrl.stream,
      body: Scaffold(
        appBar: AppBar(
          title: const Text('title'),
          leading: BackButton(onPressed: () => popped = true),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    final before = tester.getTopLeft(find.byType(BackButton)).dy;

    ctrl.add([ConnectivityResult.none]);
    await tester.pumpAndSettle();
    final msg = (await S.delegate.load(const Locale('en'))).noInternet;
    final banner =
        find.ancestor(of: find.text(msg), matching: find.byType(Material));
    final bannerBottom = tester.getBottomLeft(banner.first).dy;
    expect(tester.getBottomLeft(find.text(msg)).dy,
        lessThanOrEqualTo(bannerBottom));
    final back = find.byType(BackButton);
    expect(tester.getTopLeft(back).dy, greaterThanOrEqualTo(bannerBottom));
    expect(tester.getTopLeft(back).dy, greaterThan(before));
    await tester.tap(back.hitTestable());
    expect(popped, isTrue);
  });
}
