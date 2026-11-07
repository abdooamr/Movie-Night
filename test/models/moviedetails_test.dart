import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:flutter_test/flutter_test.dart';

const _movie = '''
{
  "adult": false,
  "backdrop_path": "/bd.jpg",
  "budget": 63000000,
  "genres": [{"id": 28, "name": "Action"}, {"id": 878, "name": "Science Fiction"}],
  "homepage": "https://example.com",
  "id": 603,
  "imdb_id": "tt0133093",
  "original_title": "The Matrix",
  "overview": "A hacker learns the truth.",
  "popularity": 85.5,
  "poster_path": "/p.jpg",
  "release_date": "1999-03-30",
  "revenue": 463517383,
  "runtime": 136,
  "status": "Released",
  "tagline": "Welcome to the Real World.",
  "title": "The Matrix",
  "video": false,
  "vote_average": 8.2,
  "vote_count": 25000
}
''';

const _tv = '''
{
  "adult": false,
  "backdrop_path": null,
  "genres": [{"id": 18, "name": "Drama"}],
  "homepage": "",
  "id": 1399,
  "original_title": null,
  "overview": "Noble families.",
  "popularity": 300,
  "poster_path": null,
  "name": "Game of Thrones",
  "first_air_date": "2011-04-17",
  "number_of_episodes": 73,
  "number_of_seasons": 8,
  "vote_average": 8,
  "vote_count": 20000
}
''';

void main() {
  test('parses a movie payload', () {
    final m = movieModelFromJson(_movie);
    expect(m.id, 603);
    expect(m.title, 'The Matrix');
    expect(m.genres.map((g) => g.name), ['Action', 'Science Fiction']);
    expect(m.releaseDate, DateTime(1999, 3, 30));
    expect(m.runtime, 136);
    expect(m.budget, 63000000);
    expect(m.imdbId, 'tt0133093');
    expect(m.voteAverage, 8.2);
    expect(m.firstAirDate, isNull);
  });

  test('parses a tv payload (no movie-only fields)', () {
    final m = movieModelFromJson(_tv);
    expect(m.name, 'Game of Thrones');
    expect(m.firstAirDate, DateTime(2011, 4, 17));
    expect(m.numberOfEpisodes, 73);
    expect(m.numberOfSeasons, 8);
    expect(m.popularity, 300.0);
    expect(m.releaseDate, isNull);
    expect(m.budget, isNull);
    expect(m.posterPath, isNull);
  });

  // Characterization: `name` is json["name"].toString(), so a movie gets "null".
  test('movie payload yields the string "null" for name (known quirk)', () {
    expect(movieModelFromJson(_movie).name, 'null');
  });

  test('toJson formats dates as yyyy-MM-dd and round-trips', () {
    final m = movieModelFromJson(_movie);
    final json = m.toJson();
    expect(json['release_date'], '1999-03-30');
    expect(json['first_air_date'], isNull);
    final again = MovieModel.fromJson(json);
    expect(again.id, m.id);
    expect(again.releaseDate, m.releaseDate);
    expect(again.genres.length, 2);
    expect(again.runtime, m.runtime);
  });

  test('Genre round trip', () {
    final g = Genre.fromJson({'id': 1, 'name': 'X'});
    expect(g.toJson(), {'id': 1, 'name': 'X'});
  });

  test('missing required genres throws', () {
    expect(() => MovieModel.fromJson({"id": 1}),
        throwsA(isA<Error>()));
  });
}
