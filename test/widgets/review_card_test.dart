import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/widgets/review_card.dart';

import '../components/_harness.dart';

const _long =
    'This is a very long review that goes on and on. It keeps going so that it '
    'will certainly overflow five lines of text at any reasonable width on a '
    'phone screen. More words here, and more words there, and even more words '
    'everywhere so the card must truncate. Still more filler text to be safe. '
    'And a final sentence to push it well over the limit of five lines.';

Widget _card(String body,
        {Future<bool> Function(BuildContext)? confirm,
        VoidCallback? onDelete}) =>
    ReviewCard(
      author: 'Ada',
      date: '01-01-2025',
      body: body,
      onDelete: onDelete,
      confirmDelete: confirm,
    );

void main() {
  testWidgets('long body shows Read more, short body does not', (t) async {
    await t.pumpWidget(harness(SizedBox(width: 300, child: _card(_long))));
    expect(find.text(S.current.readmorelabel), findsOneWidget);

    await t.pumpWidget(harness(SizedBox(width: 300, child: _card('Nice.'))));
    expect(find.text(S.current.readmorelabel), findsNothing);
  });

  testWidgets('expanding one card does not expand another', (t) async {
    await t.pumpWidget(harness(SingleChildScrollView(
      child: SizedBox(
        width: 300,
        child: Column(children: [_card(_long), _card(_long)]),
      ),
    )));
    expect(find.text(S.current.readmorelabel), findsNWidgets(2));
    await t.tap(find.text(S.current.readmorelabel).first);
    await t.pumpAndSettle();
    expect(find.text(S.current.readmorelabel), findsOneWidget);
  });

  testWidgets('delete asks the injected confirm before deleting', (t) async {
    var asked = 0;
    var deleted = 0;
    var answer = false;
    await t.pumpWidget(harness(_card(
      'Nice.',
      confirm: (_) async {
        asked++;
        return answer;
      },
      onDelete: () => deleted++,
    )));
    await t.tap(find.byTooltip(S.current.deleteReviewTooltip));
    await t.pumpAndSettle();
    expect(asked, 1);
    expect(deleted, 0);

    answer = true;
    await t.tap(find.byTooltip(S.current.deleteReviewTooltip));
    await t.pumpAndSettle();
    expect(asked, 2);
    expect(deleted, 1);
  });

  testWidgets('no delete button without onDelete', (t) async {
    await t.pumpWidget(harness(_card('Nice.')));
    expect(find.byTooltip(S.current.deleteReviewTooltip), findsNothing);
  });

  testWidgets('expand state follows the review when an earlier one is removed',
      (t) async {
    ReviewCardData d(String a) =>
        ReviewCardData(author: a, date: 'd', body: _long);
    var items = [d('A'), d('B')];
    late StateSetter set;
    await t.pumpWidget(harness(SingleChildScrollView(
      child: SizedBox(
        width: 300,
        child: StatefulBuilder(builder: (context, setState) {
          set = setState;
          return Column(children: [
            for (final i in items) ReviewCard.fromData(i),
          ]);
        }),
      ),
    )));
    await t.tap(find.text(S.current.readmorelabel).last); // expand B
    await t.pumpAndSettle();
    expect(find.text(S.current.readmorelabel), findsOneWidget);

    set(() => items = [items[1]]); // remove A
    await t.pumpAndSettle();
    expect(find.text('B'), findsOneWidget);
    expect(find.text(S.current.readmorelabel), findsNothing);
  });
}
