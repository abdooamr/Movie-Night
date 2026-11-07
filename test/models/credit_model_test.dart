import 'package:Movie_Night/src/models/credit_model.dart';
import 'package:flutter_test/flutter_test.dart';

const _credits = '''
{
  "id": 603,
  "cast": [
    {"adult": false, "gender": 2, "id": 6384, "known_for_department": "Acting",
     "name": "Keanu Reeves", "original_name": "Keanu Reeves", "popularity": 60.1,
     "profile_path": "/k.jpg", "cast_id": 34, "character": "Neo",
     "credit_id": "52fe425bc3a36847f80181c1", "order": 0}
  ],
  "crew": [
    {"adult": false, "gender": 1, "id": 9339, "known_for_department": "Directing",
     "name": "Lilly Wachowski", "original_name": "Lilly Wachowski", "popularity": 10,
     "profile_path": null, "credit_id": "52fe425bc3a36847f8018", "department": "Directing",
     "job": "Director"}
  ]
}
''';

void main() {
  final credit = creditFromJson(_credits);

  test('parses cast', () {
    expect(credit.id, 603);
    expect(credit.cast, hasLength(1));
    final c = credit.cast.first;
    expect(c.name, 'Keanu Reeves');
    expect(c.character, 'Neo');
    expect(c.castId, 34);
    expect(c.knownForDepartment, Department.acting);
    expect(c.department, isNull);
    expect(c.job, isNull);
  });

  test('parses crew with department and job', () {
    final c = credit.crew.first;
    expect(c.job, 'Director');
    expect(c.department, Department.directing);
    expect(c.knownForDepartment, Department.directing);
    expect(c.profilePath, isNull);
    expect(c.popularity, 10.0);
  });

  test('unknown department maps to null', () {
    final c = Cast.fromJson({
      'popularity': 1,
      'known_for_department': 'Lighting',
    });
    expect(c.knownForDepartment, isNull);
  });

  test('empty cast/crew lists parse', () {
    final c = Credit.fromJson({'id': 1, 'cast': [], 'crew': []});
    expect(c.cast, isEmpty);
    expect(c.crew, isEmpty);
  });

  // Characterization: EnumValues.reverseMap is `late` and never assigned, so
  // serialising a Cast throws. Delete this test when the bug is fixed.
  test('Cast.toJson throws LateInitializationError (known bug)', () {
    expect(() => credit.cast.first.toJson(), throwsA(isA<Error>()));
  });

  test('departmentValues covers every Department value', () {
    expect(departmentValues.map.values.toSet(), Department.values.toSet());
  });
}
