import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/pressable.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child, {bool disableAnimations = false}) => MaterialApp(
      theme: buildAppTheme(Brightness.dark),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: disableAnimations),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );

double _minScale(WidgetTester tester) {
  final transforms = tester.widgetList<Transform>(find.descendant(
    of: find.byType(PressableScale),
    matching: find.byType(Transform),
  ));
  var min = 1.0;
  for (final t in transforms) {
    final s = t.transform.entry(0, 0);
    if (s < min) min = s;
  }
  return min;
}

void main() {
  const box = SizedBox(width: 100, height: 100);

  testWidgets('scales down on tap-down, springs back on release',
      (tester) async {
    await tester.pumpWidget(_app(PressableScale(onTap: () {}, child: box)));
    final gesture = await tester
        .startGesture(tester.getCenter(find.byType(PressableScale)));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 300));
    expect(_minScale(tester), closeTo(0.97, 0.005));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(_minScale(tester), closeTo(1.0, 0.001));
  });

  testWidgets('no scale with disableAnimations', (tester) async {
    await tester.pumpWidget(_app(
      PressableScale(onTap: () {}, child: box),
      disableAnimations: true,
    ));
    final gesture = await tester
        .startGesture(tester.getCenter(find.byType(PressableScale)));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 300));
    expect(_minScale(tester), 1.0);
    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('tap and long press callbacks; has InkWell', (tester) async {
    var taps = 0, longs = 0;
    await tester.pumpWidget(_app(PressableScale(
      onTap: () => taps++,
      onLongPress: () => longs++,
      child: box,
    )));
    expect(find.byType(InkWell), findsOneWidget);
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();
    await tester.longPress(find.byType(InkWell));
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(longs, 1);
  });
}
