import 'dart:typed_data';

import 'package:Movie_Night/generated/l10n.dart';
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

void main() {
  const content = SizedBox(height: 400, child: Text('content'));

  testWidgets('high contrast renders only the child', (tester) async {
    await tester.pumpWidget(_app(
      SpillGlow(source: MemoryImage(_png), child: content),
      highContrast: true,
    ));
    expect(find.byType(ImageFiltered), findsNothing);
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('null source renders only the child', (tester) async {
    await tester
        .pumpWidget(_app(const SpillGlow(source: null, child: content)));
    expect(find.byType(ImageFiltered), findsNothing);
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('renders a blurred glow behind the child', (tester) async {
    await tester.pumpWidget(
        _app(SpillGlow(source: MemoryImage(_png), child: content)));
    expect(find.byType(ImageFiltered), findsOneWidget);
    expect(
      find.ancestor(
          of: find.byType(ImageFiltered),
          matching: find.byType(RepaintBoundary)),
      findsWidgets,
    );
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('cross-fades to a new source', (tester) async {
    await tester.pumpWidget(
        _app(SpillGlow(source: MemoryImage(_png), child: content)));
    final other = MemoryImage(Uint8List.fromList(_png));
    await tester.pumpWidget(_app(SpillGlow(source: other, child: content)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(ImageFiltered), findsNWidgets(2));
    await tester.pumpAndSettle();
    expect(find.byType(ImageFiltered), findsOneWidget);
  });
}
