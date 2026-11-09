import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/Provider/reviewsprovider.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/models/local_review_model.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/data/tmdb_client.dart';
import 'package:Movie_Night/src/data/tmdb_repository.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/pages/UI/detail_page.dart';
import 'package:Movie_Night/src/pages/UI/detail_preview.dart';
import 'package:Movie_Night/src/widgets/shimmerWidgets/detailPageShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

import '../components/_harness.dart';

/// No reviews, no Supabase.
class _NoReviews extends ReviewProvider {
  @override
  Stream<List<Localreviews>> getReviews(int movieId, {required bool isTv}) =>
      Stream.value(const []);
}

/// Signed out, no Supabase.
class _SignedOut extends AuthRepository {
  @override
  bool get isSignedIn => false;
  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();
}

const _localeChannel = MethodChannel('uk.spiralarm.flutter/devicelocale');

const _matrixJson = '{"adult":false,"backdrop_path":"/bd.jpg","budget":1,'
    '"genres":[{"id":28,"name":"Action"},{"id":878,"name":"Science Fiction"}],'
    '"homepage":"","id":603,"imdb_id":"tt0133093",'
    '"original_title":"The Matrix","overview":"A hacker learns the truth.",'
    '"popularity":85.5,"poster_path":"/p.jpg","release_date":"1999-03-30",'
    '"revenue":1,"runtime":136,"status":"Released","tagline":"t",'
    '"title":"The Matrix","video":false,"vote_average":8.2,"vote_count":25000}';

const _preview = DetailPreview(
  title: 'The Matrix',
  posterPath: null,
  backdropPath: null,
  year: 1999,
  voteAverage: 8.2,
  genres: ['Action'],
);

Widget _page({
  DetailPreview? preview,
  required Future<MovieModel> Function(int, bool, String) fetch,
  double textScale = 1,
}) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DropdownProvider()),
        ChangeNotifierProvider<ReviewProvider>(create: (_) => _NoReviews()),
      ],
      child: harness(Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: DetailPage(
            id: 603,
            isTvShow: false,
            preview: preview,
            fetch: fetch,
          ),
        ),
      )),
    );

/// The JustWatch logo is a network SVG; in widget tests every request
/// answers 400 and flutter_svg's test-only compute path reports the parse
/// failure (on a device its errorBuilder shows the name instead). Any other
/// exception still fails the test.
void _expectNoErrorBesidesLogo(WidgetTester tester) {
  final e = tester.takeException();
  expect(e == null || '$e'.contains('Invalid SVG data'), isTrue,
      reason: '$e');
}

/// A phone-sized screen (the default 800x600 is landscape).
void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  // The Like tile reads the on-device `liked` box, signed in or out.
  late Directory hiveDir;
  setUpAll(() async {
    hiveDir = Directory.systemTemp.createTempSync('detail_page_test');
    Hive.init(hiveDir.path);
    Hive.registerAdapter(LikedModelAdapter());
    await Hive.openBox<LikedModel>('liked', bytes: Uint8List(0));
  });
  tearDownAll(() async {
    await Hive.close();
    try {
      hiveDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  setUp(() {
    AuthRepository.instance = _SignedOut();
    // Sections below the header ask TMDB too: answer 404, never the network.
    TmdbRepository.instance = TmdbRepository(
      client: TmdbClient(
        apiKey: 'k',
        sleep: (_) async {},
        httpClient: MockClient((_) async => http.Response('', 404)),
      ),
    );
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localeChannel, (_) async => 'en_US');
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localeChannel, null);
  });

  testWidgets('with a preview, the header shows at once while details load',
      (tester) async {
    _phone(tester);
    final details = Completer<MovieModel>();
    await tester.pumpWidget(
        _page(preview: _preview, fetch: (_, __, ___) => details.future));
    await tester.pump();

    expect(find.text('The Matrix'), findsWidgets);
    expect(find.text('1999'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.byType(detailPageShimmerWidget), findsNothing);
    expect(find.text('Watch Trailers'), findsNothing); // still loading
  });

  testWidgets('details arrive: actions fade in and the meta gains the runtime',
      (tester) async {
    _phone(tester);
    final details = Completer<MovieModel>();
    await tester.pumpWidget(
        _page(preview: _preview, fetch: (_, __, ___) => details.future));
    await tester.pump();

    details.complete(movieModelFromJson(_matrixJson));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    _expectNoErrorBesidesLogo(tester);

    expect(find.text('Watch Trailers'), findsOneWidget);
    expect(find.text('1999 · 2h 16m'), findsOneWidget);
    expect(find.text('Action · Science Fiction'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget); // the third tile
  });

  testWidgets('without a preview, a skeleton until the details load',
      (tester) async {
    final details = Completer<MovieModel>();
    await tester
        .pumpWidget(_page(fetch: (_, __, ___) => details.future));
    await tester.pump();
    expect(find.byType(detailPageShimmerWidget), findsOneWidget);
  });

  testWidgets('a failed load keeps the header and offers Try Again',
      (tester) async {
    _phone(tester);
    var calls = 0;
    await tester.pumpWidget(_page(
      preview: _preview,
      fetch: (_, __, ___) {
        calls++;
        return Future<MovieModel>.error(Exception('offline'))..ignore();
      },
    ));
    await tester.pump();
    await tester.pump();

    expect(find.text('The Matrix'), findsWidgets);
    expect(find.text('Try Again'), findsOneWidget);
    await tester.tap(find.text('Try Again'));
    await tester.pump();
    expect(calls, 2);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('no overflow at text scale $scale', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_page(
        preview: _preview,
        textScale: scale,
        fetch: (_, __, ___) async => movieModelFromJson(_matrixJson),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      _expectNoErrorBesidesLogo(tester); // an overflow would fail here
      expect(find.text('Watch Trailers'), findsOneWidget);
    });
  }
}
