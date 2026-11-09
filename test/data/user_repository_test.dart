import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('watchlistFromRows', () {
    final rows = [
      {'tmdb_id': 30, 'is_tv': false, 'created_at': '2026-03-01T10:00:00Z'},
      {'tmdb_id': 10, 'is_tv': false, 'created_at': '2026-01-01T10:00:00Z'},
      {'tmdb_id': 99, 'is_tv': true, 'created_at': '2026-02-01T10:00:00Z'},
      {'tmdb_id': 20, 'is_tv': false, 'created_at': '2026-02-01T10:00:00Z'},
    ];

    test('keeps one kind, oldest first', () {
      expect(UserRepository.watchlistFromRows(rows, isTvShow: false),
          [10, 20, 30]);
      expect(UserRepository.watchlistFromRows(rows, isTvShow: true), [99]);
    });

    test('empty and malformed rows', () {
      expect(UserRepository.watchlistFromRows(const [], isTvShow: false),
          isEmpty);
      expect(
        UserRepository.watchlistFromRows([
          {'tmdb_id': null, 'is_tv': false},
          {'tmdb_id': 5.0, 'is_tv': false},
        ], isTvShow: false),
        [5],
      );
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
