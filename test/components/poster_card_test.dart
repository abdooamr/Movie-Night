import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/poster_card.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/utils/poster_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child,
        {Brightness brightness = Brightness.dark, double textScale = 1}) =>
    MaterialApp(
      theme: buildAppTheme(brightness),
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
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );

void main() {
  Widget card({VoidCallback? onTap}) => SizedBox(
        width: 170,
        child: PosterCard(
          posterPath: null,
          title: 'Dune',
          subtitle: '2021',
          onTap: onTap ?? () {},
        ),
      );

  testWidgets('meets tap target guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app(card()));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });

  testWidgets('one combined semantics label', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(_app(card(onTap: () => taps++)));
    expect(find.bySemanticsLabel('Dune, 2021'), findsOneWidget);
    final node = tester.getSemantics(find.bySemanticsLabel('Dune, 2021'));
    expect(node.label, 'Dune, 2021');
    expect(node.flagsCollection.isButton, isTrue);
    await tester.tap(find.byType(PosterCard));
    await tester.pumpAndSettle();
    expect(taps, 1);
    handle.dispose();
  });

  testWidgets('label is the title alone without subtitle', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app(SizedBox(
      width: 170,
      child: PosterCard(posterPath: null, title: 'Dune', onTap: () {}),
    )));
    expect(find.bySemanticsLabel('Dune'), findsOneWidget);
    handle.dispose();
  });

  for (final scale in [1.0, 2.0, 3.0]) {
    testWidgets('no overflow at $scale text scale in a rail-sized slot',
        (tester) async {
      // Phone-sized view: 0.42 x 405 clamps to the 170 pt rail width.
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(405, 900);
      addTearDown(tester.view.reset);
      Size? slot;
      await tester.pumpWidget(_app(
        Builder(builder: (context) {
          final size = PosterSize.of(context);
          slot = Size(size.width, size.cardHeight);
          return SizedBox(
            width: size.width,
            height: size.cardHeight,
            child: PosterCard(
              posterPath: null,
              title: 'Dune: Part Two, The Extended Long Title',
              subtitle: '2024 · Science Fiction · Adventure',
              onTap: () {},
            ),
          );
        }),
        textScale: scale,
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(slot!.width, 170);
    });
  }

  testWidgets('wraps in Hero only when heroTag given', (tester) async {
    await tester.pumpWidget(_app(card()));
    expect(find.byType(Hero), findsNothing);
    await tester.pumpWidget(_app(SizedBox(
      width: 170,
      child: PosterCard(
        posterPath: null,
        title: 'Dune',
        onTap: () {},
        heroTag: heroTagFor(source: 'trending', isTv: false, id: 1),
      ),
    )));
    expect(find.byType(Hero), findsOneWidget);
  });

  test('heroTagFor is unique across sources and media types', () {
    expect(heroTagFor(source: 'trending', isTv: false, id: 42),
        'poster-trending-movie-42');
    final tags = {
      heroTagFor(source: 'trending', isTv: false, id: 42),
      heroTagFor(source: 'popular', isTv: false, id: 42),
      heroTagFor(source: 'trending', isTv: true, id: 42),
      heroTagFor(source: 'trending', isTv: false, id: 43),
    };
    expect(tags.length, 4);
  });

  testWidgets('hero shuttle reuses the rail image', (tester) async {
    await tester.pumpWidget(_app(SizedBox(
      width: 170,
      child: PosterCard(
        posterPath: null,
        title: 'Dune',
        heroTag: 'poster-test',
        onTap: () {},
      ),
    )));
    final heroElement = tester.element(find.byType(Hero));
    final other = tester.element(find.byType(Scaffold));
    final hero = tester.widget<Hero>(find.byType(Hero));
    expect(hero.flightShuttleBuilder, isNotNull);

    // Push: the rail is the "from" side. Pop: it is the "to" side.
    final push = hero.flightShuttleBuilder!(heroElement,
        kAlwaysCompleteAnimation, HeroFlightDirection.push, heroElement, other);
    final pop = hero.flightShuttleBuilder!(heroElement,
        kAlwaysCompleteAnimation, HeroFlightDirection.pop, other, heroElement);
    expect(push, same(hero.child));
    expect(pop, same(hero.child));
  });
}
