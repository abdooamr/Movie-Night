import 'dart:ui';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.load(const Locale('en'));
  });

  test('maps ids to English names, comma separated', () {
    expect(getGenres([28, 35]), 'Action, Comedy');
  });

  test('empty list gives empty string', () {
    expect(getGenres([]), '');
  });

  test('unknown ids are skipped', () {
    expect(getGenres([28, 999999, 18]), 'Action, Drama');
  });

  test('preserves input order and duplicates', () {
    expect(getGenres([18, 28, 18]), 'Drama, Action, Drama');
  });

  test('covers movie and tv genre ids', () {
    for (final id in [
      28, 12, 16, 35, 80, 99, 18, 10751, 14, 36, 27, 10402, 9648, 10749, 878,
      10770, 53, 10752, 37, 10759, 10762, 10763, 10764, 10765, 10766, 10767,
      10768
    ]) {
      expect(getGenres([id]), isNotEmpty, reason: 'id $id');
    }
  });

  test('map is rebuilt when the locale changes', () async {
    final en = getGenres([35]);
    await S.load(const Locale('de'));
    final de = getGenres([35]);
    expect(de, isNot(en));
    await S.load(const Locale('en'));
    expect(getGenres([35]), en);
  });
}
