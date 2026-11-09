import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/pages/UI/home_page.dart';
import 'package:Movie_Night/src/widgets/Home_page_listview.dart';
import 'package:Movie_Night/src/widgets/movies_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/_harness.dart';

const _localeChannel = MethodChannel('uk.spiralarm.flutter/devicelocale');

Model _model(HomeFeed feed, int count) => Model(results: [
      for (var i = 0; i < count; i++)
        Result(
          id: feed.index * 100 + i,
          title: '${feed.name} $i',
          // A real path, so the centred item changes the glow source.
          posterPath: '/poster$i.jpg',
          genreIds: const [],
          mediaType: MediaType.movie,
        ),
    ]);

Widget _home({Future<Model> Function(HomeFeed, String)? fetch}) =>
    ChangeNotifierProvider(
      create: (_) => DropdownProvider(),
      child: harness(
        HomePage(fetch: fetch ?? (feed, _) async => _model(feed, 10)),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localeChannel, (call) async => 'en_US');
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localeChannel, null);
  });

  testWidgets('carousel swipe does not rebuild the rails', (tester) async {
    await tester.pumpWidget(_home());
    // Feeds resolve, then the sections swap their skeletons for content.
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1));
    }

    final before = tester.widget(find.byType(MoviesListView).first);
    await tester.fling(
        find.byType(PageView).first, const Offset(-300, 0), 1500);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(identical(before, tester.widget(find.byType(MoviesListView).first)),
        isTrue);
  });
}
