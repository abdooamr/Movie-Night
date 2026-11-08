import 'package:Movie_Night/src/models/credit_model.dart';
import 'package:Movie_Night/src/pages/UI/castdetails.dart';
import 'package:Movie_Night/src/widgets/cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../components/_harness.dart';

Cast _member(int id, String name, String character) => Cast(
      adult: false,
      gender: 1,
      id: id,
      knownForDepartment: null,
      name: name,
      originalName: name,
      popularity: 1,
      profilePath: null,
      castId: id,
      character: character,
      creditId: '$id',
      order: id,
      department: null,
      job: null,
    );

Widget _rail({double textScale = 1, void Function(int)? onTap}) => harness(
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: CastRail(
            cast: [
              _member(1, 'Zendaya Coleman', 'Chani Kynes of Arrakis'),
              _member(2, 'Timothee Chalamet', 'Paul Atreides'),
            ],
            onPersonTap: onTap ?? (_) {},
          ),
        ),
      ),
    );

void main() {
  testWidgets('cast item is a button labelled with name and character',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_rail());
    final node = tester.getSemantics(
      find.bySemanticsLabel(RegExp('Zendaya Coleman.*Chani Kynes')),
    );
    expect(node.flagsCollection.isButton, isTrue);
    handle.dispose();
  });

  testWidgets('tapping an item reports the person id', (tester) async {
    int? tapped;
    await tester.pumpWidget(_rail(onTap: (id) => tapped = id));
    // The InkWell overlay sits above the text, so it receives the tap.
    await tester.tap(find.text('Timothee Chalamet'), warnIfMissed: false);
    expect(tapped, 2);
  });

  testWidgets('no overflow at text scale 2.0', (tester) async {
    await tester.pumpWidget(_rail(textScale: 2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('short bio shows Read more when clamped at large text',
      (tester) async {
    await tester.pumpWidget(harness(
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: SingleChildScrollView(
            child: SizedBox(
              width: 320,
              child: PersonBio(text: 'A biography sentence. ' * 9),
            ),
          ),
        ),
      ),
    ));
    expect(find.text('Read more'), findsOneWidget);
    await tester.tap(find.text('Read more'));
    await tester.pump();
    expect(find.text('Read more'), findsNothing);
    await tester.ensureVisible(find.text('Read less'));
    await tester.pump();
    await tester.tap(find.text('Read less'));
    await tester.pump();
    expect(find.text('Read more'), findsOneWidget);
  });

  testWidgets('short bio at normal scale has no Read more', (tester) async {
    await tester.pumpWidget(harness(const SizedBox(
      width: 320,
      child: PersonBio(text: 'Short bio.'),
    )));
    expect(find.text('Read more'), findsNothing);
  });
}
