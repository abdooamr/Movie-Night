import 'dart:convert';

import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:flutter_test/flutter_test.dart';

// Fixture shaped like TMDB /trending/all/day (hand-written from the API schema).
const _listJson = '''
{
  "page": 1,
  "results": [
    {
      "adult": false,
      "backdrop_path": "/bd.jpg",
      "id": 603,
      "title": "The Matrix",
      "original_title": "The Matrix",
      "overview": "A hacker learns the truth.",
      "poster_path": "/p.jpg",
      "media_type": "movie",
      "genre_ids": [28, 878],
      "popularity": 85.5,
      "release_date": "1999-03-30",
      "video": false,
      "vote_average": 8.2,
      "vote_count": 25000
    },
    {
      "adult": false,
      "backdrop_path": null,
      "id": 1399,
      "name": "Game of Thrones",
      "original_name": "Game of Thrones",
      "overview": "Noble families.",
      "poster_path": null,
      "media_type": "tv",
      "genre_ids": [10765, 18],
      "popularity": 300,
      "first_air_date": "2011-04-17",
      "vote_average": 8,
      "vote_count": 20000,
      "origin_country": ["US"]
    }
  ],
  "total_pages": 10,
  "total_results": 200
}
''';

void main() {
  group('Model.fromJson', () {
    final model = modelFromJson(_listJson);

    test('parses paging fields', () {
      expect(model.page, 1);
      expect(model.totalPages, 10);
      expect(model.totalResults, 200);
      expect(model.results, hasLength(2));
    });

    test('parses a movie result', () {
      final r = model.results[0];
      expect(r.id, 603);
      expect(r.title, 'The Matrix');
      expect(r.genreIds, [28, 878]);
      expect(r.popularity, 85.5);
      expect(r.voteAverage, 8.2);
      expect(r.mediaType, MediaType.movie);
      expect(r.releaseDate, '1999-03-30');
      expect(r.name, isNull);
    });

    test('parses a tv result; int numbers coerce to double', () {
      final r = model.results[1];
      expect(r.name, 'Game of Thrones');
      expect(r.mediaType, MediaType.tv);
      expect(r.popularity, 300.0);
      expect(r.voteAverage, 8.0);
      expect(r.firstAirDate, '2011-04-17');
      expect(r.originCountry, ['US']);
      expect(r.posterPath, isNull);
      expect(r.backdropPath, isNull);
    });
  });

  group('Result null handling', () {
    test('tolerates missing optional fields', () {
      final r = Result.fromJson({'id': 1, 'popularity': 1});
      expect(r.genreIds, isNull);
      expect(r.voteAverage, isNull);
      expect(r.releaseDate, isNull);
      expect(r.originCountry, isNull);
      expect(r.mediaType, isNull);
    });

    test('unknown media_type maps to null', () {
      final r = Result.fromJson({'popularity': 1, 'media_type': 'collection'});
      expect(r.mediaType, isNull);
    });

    // Characterization: locks CURRENT behaviour so refactors notice a change.
    test('missing popularity throws (known fragility)', () {
      expect(() => Result.fromJson({'id': 1}), throwsA(isA<NoSuchMethodError>()));
    });

    test('toJson throws when genreIds is null (known fragility)', () {
      final r = Result.fromJson({'popularity': 1});
      expect(() => r.toJson(), throwsA(isA<TypeError>()));
    });
  });

  group('round trip', () {
    test('toJson -> fromJson preserves data', () {
      final model = modelFromJson(_listJson);
      final again = modelFromJson(modelToJson(model));
      expect(again.page, model.page);
      expect(again.totalResults, model.totalResults);
      for (var i = 0; i < model.results.length; i++) {
        final a = model.results[i], b = again.results[i];
        expect(b.id, a.id);
        expect(b.title, a.title);
        expect(b.name, a.name);
        expect(b.genreIds, a.genreIds);
        expect(b.popularity, a.popularity);
        expect(b.voteAverage, a.voteAverage);
        expect(b.releaseDate, a.releaseDate);
        expect(b.firstAirDate, a.firstAirDate);
        expect(b.originCountry, a.originCountry);
      }
    });

    test('toJson emits TMDB snake_case keys', () {
      final map = jsonDecode(modelToJson(modelFromJson(_listJson)));
      expect(map['total_pages'], 10);
      expect(map['results'][0].containsKey('poster_path'), isTrue);
      expect(map['results'][0].containsKey('genre_ids'), isTrue);
    });
  });
}
