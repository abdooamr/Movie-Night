import 'package:Movie_Night/src/models/local_review_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  const row = {
    'id': 7,
    'movie_id': 603,
    'user_id': '9f1c0d3e-0000-4000-8000-000000000001',
    'review': 'Still holds up.',
    'created_at': '2026-03-05T12:00:00+00:00',
  };
  const author = {
    'id': '9f1c0d3e-0000-4000-8000-000000000001',
    'first_name': 'Ada',
    'last_name': 'Lovelace',
    'profile_pic': 'https://example.com/a.jpg',
  };

  setUpAll(() => initializeDateFormatting());

  test('row + author map to what the card shows', () {
    final r = Localreviews.fromRow(row,
        author: author, format: DateFormat('dd-MM-yyyy', 'en'));
    final local = DateTime.parse('2026-03-05T12:00:00+00:00').toLocal();
    expect(r.review, 'Still holds up.');
    expect(r.displayname, 'Ada Lovelace');
    expect(r.ProfilePic, 'https://example.com/a.jpg');
    expect(r.id, '9f1c0d3e-0000-4000-8000-000000000001');
    expect(r.createdat, DateFormat('dd-MM-yyyy', 'en').format(local));
    expect(r.createdat, matches(RegExp(r'^\d\d-\d\d-2026$')));
  });

  test('Arabic keeps the dd-MM-yyyy pattern (current intl: Western digits)',
      () {
    // Older intl versions wrote Arabic-Indic digits for `ar`, which is why
    // some imported Firestore dates have them; today's intl uses Western
    // digits for `ar`, like every other date in the app.
    final r = Localreviews.fromRow(row,
        author: author, format: DateFormat('dd-MM-yyyy', 'ar'));
    final local = DateTime.parse('2026-03-05T12:00:00+00:00').toLocal();
    expect(r.createdat, DateFormat('dd-MM-yyyy', 'ar').format(local));
    expect(r.createdat, endsWith('2026'));
  });

  test('unknown author and bad date fall back to empty strings', () {
    final r = Localreviews.fromRow(
        {...row, 'created_at': 'not a date', 'review': null});
    expect(r.displayname, '');
    expect(r.ProfilePic, '');
    expect(r.createdat, '');
    expect(r.review, isNull);
  });

  test('a one-part name has no stray space', () {
    final r = Localreviews.fromRow(row,
        author: {...author, 'last_name': '  '},
        format: DateFormat('dd-MM-yyyy', 'en'));
    expect(r.displayname, 'Ada');
  });
}
