import 'package:Movie_Night/src/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Users.fromFirestore', () {
    test('reads the canonical Register_provider shape', () {
      final u = Users.fromFirestore({
        'id': 'u1',
        'role': 'User',
        'ProfilePic': 'https://x/p.png',
        'firstName': 'Ada',
        'lastName': 'Lovelace',
        'email': 'ada@example.com',
        'report': '',
      });
      expect(u.id, 'u1');
      expect(u.firstName, 'Ada');
      expect(u.lastName, 'Lovelace');
      expect(u.email, 'ada@example.com');
      expect(u.role, 'User');
      expect(u.report, '');
    });

    test('reads the legacy googleauth.dart shape', () {
      final u = Users.fromFirestore({
        'role': 'User',
        'email': 'ada@example.com',
        'firstname': 'Ada Lovelace',
        'ProfilePic': 'https://x/p.png',
        'lastname': '',
        'id': 'u2',
        'report': ' ',
      });
      expect(u.firstName, 'Ada Lovelace');
      expect(u.lastName, '');
      expect(u.id, 'u2');
    });

    test('canonical field wins when both are present', () {
      final u = Users.fromFirestore({
        'firstName': 'New',
        'firstname': 'Old',
        'lastName': 'Name',
        'lastname': 'Stale',
      });
      expect(u.firstName, 'New');
      expect(u.lastName, 'Name');
    });

    test('missing / wrong-typed fields do not throw', () {
      final u = Users.fromFirestore({'ProfilePic': null, 'role': 3});
      expect(u.firstName, '');
      expect(u.lastName, '');
      expect(u.email, '');
      expect(u.ProfilePic, '');
      expect(u.role, 'User');
      expect(u.id, isNull);
    });
  });

  group('Users.splitDisplayName', () {
    test('one word -> empty last name (used to RangeError)', () {
      final n = Users.splitDisplayName('Ada');
      expect(n.first, 'Ada');
      expect(n.last, '');
    });

    test('two words', () {
      final n = Users.splitDisplayName('Ada Lovelace');
      expect(n.first, 'Ada');
      expect(n.last, 'Lovelace');
    });

    test('three+ words keep the rest as last name', () {
      final n = Users.splitDisplayName('  Ada   King Lovelace ');
      expect(n.first, 'Ada');
      expect(n.last, 'King Lovelace');
    });

    test('null / blank', () {
      expect(Users.splitDisplayName(null).first, '');
      expect(Users.splitDisplayName('   ').last, '');
    });
  });
}
