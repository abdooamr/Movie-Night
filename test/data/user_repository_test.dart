import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('watchlistEntriesFromRows', () {
    final rows = [
      {'tmdb_id': 30, 'is_tv': false, 'created_at': '2026-03-01T10:00:00Z'},
      {'tmdb_id': 10, 'is_tv': false, 'created_at': '2026-01-01T10:00:00Z'},
      {'tmdb_id': 99, 'is_tv': true, 'created_at': '2026-02-01T10:00:00Z'},
    ];

    test('movies and TV together, newest first', () {
      final e = UserRepository.watchlistEntriesFromRows(rows);
      expect([for (final x in e) x.tmdbId], [30, 99, 10]);
      expect([for (final x in e) x.isTv], [false, true, false]);
    });

    test('empty and malformed rows', () {
      expect(UserRepository.watchlistEntriesFromRows(const []), isEmpty);
      final e = UserRepository.watchlistEntriesFromRows([
        {'tmdb_id': null, 'is_tv': false},
        {'tmdb_id': 5.0, 'is_tv': false},
        {'tmdb_id': 6, 'is_tv': 'yes'},
        {'tmdb_id': 7, 'is_tv': true, 'created_at': 'not a date'},
      ]);
      expect([for (final x in e) x.tmdbId], [5, 7]);
    });
  });

  test('avatarContentType follows the extension', () {
    expect(UserRepository.avatarContentType('/x/pic.PNG'), 'image/png');
    expect(UserRepository.avatarContentType('/x/pic.webp'), 'image/webp');
    expect(UserRepository.avatarContentType('/x/pic.jpg'), 'image/jpeg');
    expect(UserRepository.avatarContentType('/x/pic.jpeg'), 'image/jpeg');
    expect(UserRepository.avatarContentType('/x/noext'), 'image/jpeg');
  });
}
