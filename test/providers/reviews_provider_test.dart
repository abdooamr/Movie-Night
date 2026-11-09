import 'package:Movie_Night/src/Provider/reviewsprovider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mediaTypeOf', () {
    expect(ReviewProvider.mediaTypeOf(isTv: false), 'movie');
    expect(ReviewProvider.mediaTypeOf(isTv: true), 'tv');
  });

  group('visibleOn', () {
    const movieRow = {'movie_id': 1399, 'media_type': 'movie'};
    const tvRow = {'movie_id': 1399, 'media_type': 'tv'};
    const legacyRow = {'movie_id': 1399, 'media_type': null};
    const noColumnRow = {'movie_id': 1399}; // before the SQL ran

    test('the movie page shows movie and legacy reviews', () {
      expect(ReviewProvider.visibleOn(movieRow, isTv: false), isTrue);
      expect(ReviewProvider.visibleOn(tvRow, isTv: false), isFalse);
      expect(ReviewProvider.visibleOn(legacyRow, isTv: false), isTrue);
    });

    test('the TV page shows TV and legacy reviews', () {
      expect(ReviewProvider.visibleOn(tvRow, isTv: true), isTrue);
      expect(ReviewProvider.visibleOn(movieRow, isTv: true), isFalse);
      expect(ReviewProvider.visibleOn(legacyRow, isTv: true), isTrue);
    });

    test('rows without the column count as legacy (shown on both)', () {
      expect(ReviewProvider.visibleOn(noColumnRow, isTv: true), isTrue);
      expect(ReviewProvider.visibleOn(noColumnRow, isTv: false), isTrue);
    });
  });
}
