import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('series genres use the short names, without "TV Shows"', () async {
    await S.load(const Locale('en'));
    expect(getGenres([10759, 18]), 'Action & Adventure, Drama');
    expect(getGenres([10765, 10768, 10762]),
        'Sci-Fi & Fantasy, War & Politics, Kids');
    expect(getGenres([10759, 10765, 10768]), isNot(contains('TV')));
  });
}
