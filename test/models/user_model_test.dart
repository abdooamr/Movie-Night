import 'package:Movie_Night/src/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Users.fromRow', () {
    test('maps a profiles row', () {
      final u = Users.fromRow({
        'id': '9f1c0d3e-0000-4000-8000-000000000001',
        'first_name': ' Ada ',
        'last_name': 'Lovelace',
        'profile_pic': 'https://example.com/a.jpg',
        'role': 'admin',
        'report': 'Broken poster',
        'firebase_uid': 'ignored',
      }, email: 'ada@example.com');
      expect(u.id, '9f1c0d3e-0000-4000-8000-000000000001');
      expect(u.firstName, 'Ada');
      expect(u.lastName, 'Lovelace');
      expect(u.ProfilePic, 'https://example.com/a.jpg');
      expect(u.role, 'admin');
      expect(u.report, 'Broken poster');
      expect(u.email, 'ada@example.com');
    });

    test('an email column (admin_list_users) wins over the argument', () {
      final u = Users.fromRow({'id': 'x', 'email': 'row@example.com'},
          email: 'arg@example.com');
      expect(u.email, 'row@example.com');
    });

    test('nulls and wrong types fall back instead of throwing', () {
      final u = Users.fromRow({
        'id': 'x',
        'first_name': null,
        'profile_pic': null,
        'role': 3,
      });
      expect(u.firstName, '');
      expect(u.lastName, '');
      expect(u.ProfilePic, '');
      expect(u.role, 'User');
      expect(u.report, isNull);
      expect(u.email, '');
    });
  });
}
