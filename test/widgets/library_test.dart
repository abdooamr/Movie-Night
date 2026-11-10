import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/data/tmdb_client.dart';
import 'package:Movie_Night/src/data/tmdb_repository.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/pages/UI/library_page.dart';
import 'package:Movie_Night/src/pages/UI/liked.dart';
import 'package:Movie_Night/src/widgets/library_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeChannel = MethodChannel('uk.spiralarm.flutter/devicelocale');

LikedModel _m(int id, String title, {bool? isTv = false}) => LikedModel(
      isLiked: true,
      title: title,
      genres: 'Drama',
      voteAverage: 7.3,
      posterPath: '',
      id: id,
      isTvShow: isTv,
    );

/// Watchlist backed by a test-controlled stream; counts subscriptions.
class _FakeUsers extends UserRepository {
  StreamController<List<WatchlistEntry>> controller =
      StreamController<List<WatchlistEntry>>();
  int subscriptions = 0;
  final removed = <int>[];
  final added = <int>[];

  @override
  Stream<List<WatchlistEntry>> watchlistEntries() {
    subscriptions++;
    controller = StreamController<List<WatchlistEntry>>();
    return controller.stream;
  }

  @override
  Future<void> removeFromWatchlist(int id, {required bool isTvShow}) async =>
      removed.add(id);

  @override
  Future<void> addToWatchlist(int id, {required bool isTvShow}) async =>
      added.add(id);
}

/// TMDB answering every details request with "Title <id>" (1999).
TmdbRepository _fakeTmdb() => TmdbRepository(
      client: TmdbClient(
        apiKey: 'k',
        sleep: (_) async {},
        httpClient: MockClient((req) async {
          final id = int.parse(req.url.pathSegments.last);
          final isTv = req.url.pathSegments.contains('tv');
          final key = isTv ? 'name' : 'title';
          final date = isTv ? 'first_air_date' : 'release_date';
          return http.Response(
            '{"adult":false,"backdrop_path":null,"budget":1,"genres":[],'
            '"homepage":"","id":$id,"imdb_id":"tt0","original_title":"o",'
            '"overview":"","popularity":1.0,"poster_path":null,'
            '"$date":"1999-03-30","revenue":1,"runtime":100,'
            '"status":"Released","tagline":"","$key":"Title $id",'
            '"video":false,"vote_average":7.0,"vote_count":1}',
            200,
          );
        }),
      ),
    );

Widget _app(Widget child, {bool sliver = true}) => ChangeNotifierProvider(
      create: (_) => DropdownProvider(),
      child: MaterialApp(
        theme: buildAppTheme(Brightness.dark),
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: sliver
            ? Scaffold(body: CustomScrollView(slivers: [child]))
            : child,
      ),
    );

const _matrix = WatchlistEntry(tmdbId: 603, isTv: false);
const _dark = WatchlistEntry(tmdbId: 70523, isTv: true);

void main() {
  late Directory dir;
  late Box<LikedModel> box;
  late _FakeUsers users;

  setUpAll(() {
    dir = Directory.systemTemp.createTempSync('library_test');
    Hive.init(dir.path);
    Hive.registerAdapter(LikedModelAdapter());
  });

  setUp(() async {
    // In-memory backend: no disk writes left pending in the fake-async zone.
    box = await Hive.openBox<LikedModel>('liked', bytes: Uint8List(0));
    UserRepository.instance = users = _FakeUsers();
    TmdbRepository.instance = _fakeTmdb();
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localeChannel, (_) async => 'en_US');
  });

  tearDown(() async {
    await box.close();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localeChannel, null);
  });

  tearDownAll(() async {
    await Hive.close();
    try {
      dir.deleteSync(recursive: true);
    } catch (_) {}
  });

  // Seeds outside the fake-async zone so the puts resolve before pumping.
  Future<void> seed(WidgetTester tester, Map<String, LikedModel> items) =>
      tester.runAsync(() async {
        for (final e in items.entries) {
          await box.put(e.key, e.value);
        }
      });

  /// TMDB details are parsed with compute(), which needs real time.
  /// Lets a stream event land and the posters' details resolve.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  group('Liked', () {
    testWidgets('a grid of posters, newest first, with a count',
        (tester) async {
      phone(tester);
      await seed(tester, {'a': _m(1, 'Alpha'), 'b': _m(2, 'Beta')});
      await tester.pumpWidget(_app(LikedView(box: box)));
      await tester.pump();

      expect(find.byType(SliverGrid), findsOneWidget);
      expect(find.text('2 titles'), findsOneWidget);
      expect(tester.getTopLeft(find.text('Beta')).dx,
          lessThan(tester.getTopLeft(find.text('Alpha')).dx));
    });

    testWidgets('long-press, Remove from Liked, then Undo', (tester) async {
      phone(tester);
      await seed(tester, {'a': _m(1, 'Alpha'), 'b': _m(2, 'Beta')});
      await tester.pumpWidget(_app(LikedView(box: box)));
      await tester.pump();

      await tester.longPress(find.text('Alpha'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove from Liked'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(box.length, 1);
      expect(find.text(S.current.removedFromLiked), findsOneWidget);
      await tester.tap(find.text(S.current.undo));
      await tester.pump();
      expect(box.length, 2);
      expect(box.get('a')?.title, 'Alpha');
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('Cancel in the sheet keeps the title', (tester) async {
      phone(tester);
      await seed(tester, {'a': _m(1, 'Alpha')});
      await tester.pumpWidget(_app(LikedView(box: box)));
      await tester.pump();

      await tester.longPress(find.text('Alpha'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(S.current.cancelLabel));
      await tester.pumpAndSettle();
      expect(box.length, 1);
    });

    testWidgets('empty shows Browse Movies', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(LikedView(box: box)));
      await tester.pump();
      expect(find.text(S.current.nolikedmovies), findsOneWidget);
      expect(find.text(S.current.browseMovies), findsOneWidget);
    });

    testWidgets('the TV filter keeps shows; nothing left offers Show All',
        (tester) async {
      phone(tester);
      await seed(tester, {
        'a': _m(1, 'Alpha'),
        'b': _m(2, 'Show', isTv: true),
        'c': _m(3, 'Legacy', isTv: null), // counts as a movie
      });
      await tester.pumpWidget(
          _app(LikedView(box: box, filter: LibraryFilter.tv)));
      await tester.pump();
      expect(find.text('Show'), findsOneWidget);
      expect(find.text('Alpha'), findsNothing);
      expect(find.text('Legacy'), findsNothing);
      expect(find.text('1 title'), findsOneWidget);

      await tester.runAsync(() => box.delete('b'));
      var shown = 0;
      await tester.pumpWidget(_app(LikedView(
        box: box,
        filter: LibraryFilter.tv,
        onShowAll: () => shown++,
      )));
      await tester.pump();
      expect(find.text(S.current.libraryNoMatches), findsOneWidget);
      await tester.tap(find.text(S.current.showAll));
      expect(shown, 1);
    });
  });

  group('Library', () {
    testWidgets('signed in opens on the Watchlist: skeleton, then posters',
        (tester) async {
      phone(tester);
      await tester.pumpWidget(
          _app(const LibraryPage(isSignedIn: true), sliver: false));
      await tester.pump();
      expect(find.byType(LibraryTileSkeleton), findsWidgets);

      users.controller.add([_matrix, _dark]);
      await settle(tester);
      expect(find.text('Title 603'), findsOneWidget);
      expect(find.text('Movie · 1999'), findsOneWidget);
      expect(find.text('Title 70523'), findsOneWidget);
      expect(find.text('TV Show · 1999'), findsOneWidget);
      expect(find.text('2 titles'), findsOneWidget);
    });

    testWidgets('switching shelves keeps one subscription and shows no error',
        (tester) async {
      phone(tester);
      await tester.pumpWidget(
          _app(const LibraryPage(isSignedIn: true), sliver: false));
      await tester.pump();
      users.controller.add([_matrix]);
      await settle(tester);

      for (final shelf in ['Liked', 'Watchlist', 'Liked', 'Watchlist']) {
        await tester.tap(find.text(shelf));
        await tester.pump();
        expect(find.byType(ErrorState), findsNothing);
      }
      await settle(tester);
      expect(users.subscriptions, 1);
      expect(find.text('Title 603'), findsOneWidget);
    });

    testWidgets('a failed first load offers Try Again, which reloads',
        (tester) async {
      phone(tester);
      await tester.pumpWidget(
          _app(const LibraryPage(isSignedIn: true), sliver: false));
      await tester.pump();
      users.controller.addError(Exception('offline'));
      await settle(tester);
      expect(find.text(S.current.tryAgain), findsOneWidget);

      await tester.tap(find.text(S.current.tryAgain));
      await tester.pump();
      expect(users.subscriptions, 2);
      users.controller.add([_matrix]);
      await settle(tester);
      expect(find.text('Title 603'), findsOneWidget);
    });

    testWidgets('a failed reload keeps the list on screen', (tester) async {
      phone(tester);
      await tester.pumpWidget(
          _app(const LibraryPage(isSignedIn: true), sliver: false));
      await tester.pump();
      users.controller.add([_matrix]);
      await settle(tester);

      users.controller.addError(Exception('offline'));
      await settle(tester);
      expect(find.byType(ErrorState), findsNothing);
      expect(find.text('Title 603'), findsOneWidget);
    });

    testWidgets('long-press removes from the Watchlist, Undo puts it back',
        (tester) async {
      phone(tester);
      await tester.pumpWidget(
          _app(const LibraryPage(isSignedIn: true), sliver: false));
      await tester.pump();
      users.controller.add([_matrix]);
      await settle(tester);

      await tester.longPress(find.text('Title 603'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(S.current.removefromwatchlist));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(users.removed, [603]);

      await tester.tap(find.text(S.current.undo));
      await tester.pump();
      expect(users.added, [603]);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('the filter menu narrows both shelves', (tester) async {
      phone(tester);
      await tester.pumpWidget(
          _app(const LibraryPage(isSignedIn: true), sliver: false));
      await tester.pump();
      users.controller.add([_matrix, _dark]);
      await settle(tester);

      await tester.tap(find.byTooltip(S.current.filterLabel));
      await tester.pumpAndSettle();
      await tester.tap(find.text(S.current.tvswitch).last);
      await tester.pumpAndSettle();

      expect(find.text('Title 70523'), findsOneWidget);
      expect(find.text('Title 603'), findsNothing);
      expect(find.text('1 title'), findsOneWidget);
    });
  });
}
