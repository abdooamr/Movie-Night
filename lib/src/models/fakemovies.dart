import 'package:Movie_Night/src/models/movie_model.dart';

class FakeDataGenerator {
  static List<Result> generateFakeMovies(int count) {
    List<Result> fakeMovies = [];

    for (int i = 0; i < count; i++) {
      Result fakeMovie = Result(
        id: i,
        title: 'Movie Title $i',
        name: 'Movie Name $i',
        posterPath: '/99grtO68doMBbU777EwIE3pFqbv.jpg',
        genreIds: [i % 3], // Example genre ID
        mediaType: MediaType.movie,
      );

      fakeMovies.add(fakeMovie);
    }

    return fakeMovies;
  }
}
