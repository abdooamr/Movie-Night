import 'dart:io';
import 'dart:typed_data';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/pages/UI/liked.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

LikedModel _m(int id, String title) => LikedModel(
      isLiked: true,
      title: title,
      genres: 'Drama',
      voteAverage: 7.3,
      posterPath: '',
      id: id,
      isTvShow: false,
    );

Widget _app(Widget sliver) => MaterialApp(
      theme: buildAppTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: CustomScrollView(slivers: [sliver])),
    );

void main() {
  late Directory dir;
  late Box<LikedModel> box;

  setUpAll(() {
    dir = Directory.systemTemp.createTempSync('library_test');
    Hive.init(dir.path);
    Hive.registerAdapter(LikedModelAdapter());
  });

  setUp(() async {
    // In-memory backend: no disk writes left pending in the fake-async zone.
    box = await Hive.openBox<LikedModel>('liked_test', bytes: Uint8List(0));
  });

  tearDown(() async {
    await box.close();
  });

  tearDownAll(() async {
    await Hive.close();
    try {
      dir.deleteSync(recursive: true);
    } catch (_) {}
  });

  // Seeds outside the fake-async zone so the puts resolve before pumping.
  Future<void> _seed(WidgetTester tester, Box<LikedModel> box) =>
      tester.runAsync(() async {
        await box.put('a', _m(1, 'Alpha'));
        await box.put('b', _m(2, 'Beta'));
      });

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('remove deletes immediately and Undo restores', (tester) async {
    phone(tester);
    await _seed(tester, box);
    await tester.pumpWidget(_app(LikedView(box: box)));
    await tester.pump();

    expect(box.length, 2);
    await tester.tap(find.byTooltip(S.current.deleteBookmark).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(box.length, 1);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(S.current.removedFromLiked), findsOneWidget);
    expect(find.text(S.current.undo), findsOneWidget);

    await tester.tap(find.text(S.current.undo));
    await tester.pump();
    expect(box.length, 2);
    expect(box.get('a')?.title, 'Alpha');
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });

  testWidgets('empty box shows Browse Movies', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(LikedView(box: box)));
    await tester.pump();
    expect(find.text(S.current.nolikedmovies), findsOneWidget);
    expect(find.text(S.current.browseMovies), findsOneWidget);
  });

  testWidgets('regular width shows a grid of cards', (tester) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _seed(tester, box);
    await tester.pumpWidget(_app(LikedView(box: box)));
    await tester.pump();
    expect(find.byType(SliverGrid), findsOneWidget);
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
  });
}
