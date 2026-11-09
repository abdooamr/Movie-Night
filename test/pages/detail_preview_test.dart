import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/pages/UI/detail_preview.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => S.load(const Locale('en')));

  test('fromResult: movie fields', () {
    final p = DetailPreview.fromResult(
      Result(
        id: 603,
        title: 'The Matrix',
        name: null,
        posterPath: '/p.jpg',
        backdropPath: '/b.jpg',
        releaseDate: '1999-03-30',
        voteAverage: 8.2,
        genreIds: const [28, 878],
      ),
      isTv: false,
    );
    expect(p.title, 'The Matrix');
    expect(p.posterPath, '/p.jpg');
    expect(p.backdropPath, '/b.jpg');
    expect(p.year, 1999);
    expect(p.voteAverage, 8.2);
    expect(p.genres, ['Action', 'Science Fiction']);
  });

  test('fromResult: TV uses name and first air date; bad dates are null', () {
    final tv = DetailPreview.fromResult(
      Result(id: 1, name: 'Dark', firstAirDate: '2017-12-01'),
      isTv: true,
    );
    expect(tv.title, 'Dark');
    expect(tv.year, 2017);
    expect(tv.genres, isEmpty);
    final bad = DetailPreview.fromResult(
      Result(id: 2, title: 'X', releaseDate: ''),
      isTv: false,
    );
    expect(bad.year, isNull);
  });

  test('formatRuntime', () {
    final s = S.current;
    expect(formatRuntime(s, 173), '2h 53m');
    expect(formatRuntime(s, 120), '2h');
    expect(formatRuntime(s, 45), '45m');
  });

  test('season and episode plurals', () {
    expect(S.current.seasonsCount(1), '1 season');
    expect(S.current.seasonsCount(3), '3 seasons');
    expect(S.current.episodesCount(1), '1 episode');
    expect(S.current.episodesCount(24), '24 episodes');
  });

  test('tmdbBackdrop picks a size that covers the screen', () {
    const base = 'https://image.tmdb.org/t/p';
    expect(tmdbBackdrop('/b.jpg', 64), '$base/w300/b.jpg');
    expect(tmdbBackdrop('/b.jpg', 720), '$base/w780/b.jpg');
    expect(tmdbBackdrop('/b.jpg', 1080), '$base/w1280/b.jpg');
    expect(tmdbBackdrop('/b.jpg', 0), '$base/w780/b.jpg');
  });
}
