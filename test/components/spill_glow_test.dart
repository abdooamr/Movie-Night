import 'dart:typed_data';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/glow_baker.dart';
import 'package:Movie_Night/src/components/spill_glow.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

// 1x1 transparent PNG.
final _png = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

Widget _app(Widget child, {bool highContrast = false}) => MaterialApp(
      theme: buildAppTheme(Brightness.dark, highContrast: highContrast),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(highContrast: highContrast),
          child: Scaffold(body: child),
        ),
      ),
    );

/// Bakes [source] outside fake async, so the widget finds it in the cache.
Future<void> _prime(WidgetTester tester, ImageProvider source) =>
    tester.runAsync(() async {
      (await bakeGlow(source, ImageConfiguration.empty))?.dispose();
    });

void main() {
  const content = SizedBox(height: 400, child: Text('content'));

  tearDown(debugClearGlowCache);

  testWidgets('high contrast renders only the child', (tester) async {
    final src = MemoryImage(_png);
    await _prime(tester, src);
    await tester.pumpWidget(_app(
      SpillGlow(source: src, child: content),
      highContrast: true,
    ));
    expect(find.byType(RawImage), findsNothing);
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('null source renders only the child', (tester) async {
    await tester
        .pumpWidget(_app(const SpillGlow(source: null, child: content)));
    expect(find.byType(RawImage), findsNothing);
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('renders a baked glow behind the child', (tester) async {
    final src = MemoryImage(_png);
    await _prime(tester, src);
    await tester.pumpWidget(_app(SpillGlow(source: src, child: content)));
    expect(find.byType(RawImage), findsOneWidget);
    // No live filter left in the tree: the blur happened at bake time.
    expect(find.byType(ImageFiltered), findsNothing);
    expect(
      find.ancestor(
          of: find.byType(RawImage), matching: find.byType(RepaintBoundary)),
      findsWidgets,
    );
    final raw = tester.widget<RawImage>(find.byType(RawImage));
    expect(raw.image!.width, GlowBake.width);
    expect(raw.fit, BoxFit.fill);
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('bakes on its own when the source is not cached',
      (tester) async {
    await tester.pumpWidget(
        _app(SpillGlow(source: MemoryImage(_png), child: content)));
    expect(find.byType(RawImage), findsNothing);
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pump();
    expect(find.byType(RawImage), findsOneWidget);
  });

  testWidgets('cross-fades to a new source', (tester) async {
    final first = MemoryImage(_png);
    final other = MemoryImage(Uint8List.fromList(_png));
    await _prime(tester, first);
    await _prime(tester, other);
    await tester.pumpWidget(_app(SpillGlow(source: first, child: content)));
    await tester.pumpWidget(_app(SpillGlow(source: other, child: content)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(RawImage), findsNWidgets(2));
    await tester.pumpAndSettle();
    expect(find.byType(RawImage), findsOneWidget);
  });

  testWidgets('failed image renders only the child', (tester) async {
    final bad = MemoryImage(Uint8List.fromList(const [1, 2, 3, 4]));
    await _prime(tester, bad);
    await tester.pumpWidget(_app(SpillGlow(source: bad, child: content)));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pump();
    expect(find.byType(RawImage), findsNothing);
    expect(find.text('content'), findsOneWidget);
  });
}
