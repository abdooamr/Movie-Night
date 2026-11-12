import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/pages/UI/home_page.dart';
import 'package:Movie_Night/src/widgets/Home_page_listview.dart';
import 'package:Movie_Night/src/widgets/movies_listview.dart';
import 'package:Movie_Night/src/widgets/upcoming.dart';
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

/// Home under a [PrimaryScrollController], as the app shell provides.
Widget _home({
  Future<Model> Function(HomeFeed, String)? fetch,
  ScrollController? controller,
  DropdownProvider? lang,
}) {
  Widget home = HomePage(fetch: fetch ?? (feed, _) async => _model(feed, 10));
  if (controller != null) {
    home = PrimaryScrollController(controller: controller, child: home);
  }
  if (lang != null) {
    return ChangeNotifierProvider.value(value: lang, child: harness(home));
  }
  return ChangeNotifierProvider(
    create: (_) => DropdownProvider(),
    child: harness(home),
  );
}

/// Feeds resolve, then the sections swap their skeletons for content.
Future<void> _load(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
}

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
    await _load(tester);

    final before = tester.widget(find.byType(MoviesListView).first);
    await tester.fling(
        find.byType(PageView).first, const Offset(-300, 0), 1500);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(identical(before, tester.widget(find.byType(MoviesListView).first)),
        isTrue);
  });

  testWidgets('rails below the fold are not built', (tester) async {
    await tester.pumpWidget(_home());
    await _load(tester);

    expect(
      find.byType(MoviesListView, skipOffstage: false).evaluate().length,
      lessThan(3),
    );

    await tester.scrollUntilVisible(
      find.text('Egyptian Movies'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Egyptian Movies'), findsOneWidget);
  });

  testWidgets('mode switch jumps to top and builds only the new mode',
      (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final fetched = <HomeFeed>[];
    await tester.pumpWidget(_home(
      controller: controller,
      fetch: (feed, _) async {
        fetched.add(feed);
        return _model(feed, 10);
      },
    ));
    await _load(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
    await tester.pump(const Duration(seconds: 1));
    expect(controller.offset, greaterThan(0));

    await tester.tap(find.text('Series'));
    await tester.pump();

    expect(controller.offset, 0);
    expect(fetched, contains(HomeFeed.airingToday));
    // One hero section, not two cross-fading trees.
    expect(find.byType(UpcomingMovies, skipOffstage: false), findsOneWidget);
  });

  test('series: Trending is the carousel, Airing Today the first rail', () {
    expect(HomeFeed.tvFeeds, [
      HomeFeed.trendingTv,
      HomeFeed.airingToday,
      HomeFeed.popularTv,
      HomeFeed.egyptianTv,
    ]);
  });

  testWidgets('a language change reloads the feeds in the new language',
      (tester) async {
    final langs = DropdownProvider();
    final seen = <String>[];
    await tester.pumpWidget(_home(
      lang: langs,
      fetch: (feed, lang) async {
        seen.add('${feed.name}/$lang');
        return _model(feed, 10);
      },
    ));
    await _load(tester);
    expect(seen, contains('upcoming/en'));
    expect(seen, isNot(contains('upcoming/ar')));

    langs.setSelectedValue('ar');
    await _load(tester);
    expect(seen, contains('upcoming/ar'));
    expect(seen, contains('trending/ar'));
  });
}
