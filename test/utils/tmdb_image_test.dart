import 'package:Movie_Night/src/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const base = 'https://image.tmdb.org/t/p';

  test('picks the smallest size that covers 90% of the width', () {
    expect(tmdbImage('/a.jpg', 40), '$base/w92/a.jpg');
    expect(tmdbImage('/a.jpg', 100), '$base/w92/a.jpg');
    expect(tmdbImage('/a.jpg', 110), '$base/w154/a.jpg');
    expect(tmdbImage('/a.jpg', 300), '$base/w342/a.jpg');
    expect(tmdbImage('/a.jpg', 510), '$base/w500/a.jpg');
  });

  test('90% tolerance: 380 px still uses w342 (342 >= 342)', () {
    expect(tmdbImage('/a.jpg', 380), '$base/w342/a.jpg');
    expect(tmdbImage('/a.jpg', 381), '$base/w500/a.jpg');
  });

  test('caps at w780', () {
    expect(tmdbImage('/a.jpg', 2000), '$base/w780/a.jpg');
  });

  test('unknown or invalid width falls back to the old w500', () {
    expect(tmdbImage('/a.jpg', 0), '$base/w500/a.jpg');
    expect(tmdbImage('/a.jpg', double.infinity), '$base/w500/a.jpg');
    expect(tmdbImage('/a.jpg', double.nan), '$base/w500/a.jpg');
  });
}
