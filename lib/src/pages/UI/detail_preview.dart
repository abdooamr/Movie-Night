import 'package:flutter/foundation.dart';

import '../../../generated/l10n.dart';
import '../../models/movie_model.dart';
import '../../models/moviedetails.dart';
import '../../utils/utils.dart' show getGenres;

/// What the detail page's header needs. Built from the rail item that was
/// tapped (so the header, and the poster's Hero flight, appear instantly) and
/// replaced by the full details once they load.
@immutable
class DetailPreview {
  const DetailPreview({
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.year,
    this.voteAverage,
    this.genres = const [],
  });

  final String title;
  final String? posterPath;
  final String? backdropPath;
  final int? year;
  final double? voteAverage;

  /// Genre names, in TMDB order.
  final List<String> genres;

  /// From a feed / search / similar item.
  factory DetailPreview.fromResult(Result r, {required bool isTv}) {
    final date = isTv ? r.firstAirDate : r.releaseDate;
    final genres = getGenres(r.genreIds ?? const []);
    return DetailPreview(
      title: (isTv ? r.name : r.title) ?? r.title ?? r.name ?? '',
      posterPath: r.posterPath,
      backdropPath: r.backdropPath,
      year: date == null || date.length < 4
          ? null
          : int.tryParse(date.substring(0, 4)),
      voteAverage: r.voteAverage,
      genres: genres.isEmpty ? const [] : genres.split(', '),
    );
  }

  /// From the full details.
  factory DetailPreview.fromDetails(MovieModel d, {required bool isTv}) =>
      DetailPreview(
        title: (isTv ? d.name : d.title) ?? '',
        posterPath: d.posterPath,
        backdropPath: d.backdropPath,
        year: (isTv ? d.firstAirDate : d.releaseDate)?.year,
        voteAverage: d.voteAverage,
        genres: [for (final g in d.genres) g.name],
      );
}

/// Runtime as "2h 53m" / "2h" / "45m" (localized).
String formatRuntime(S s, int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return s.runtimeMinutesOnly(m);
  if (m == 0) return s.runtimeHoursOnly(h);
  return s.runtimeHoursMinutes(h, m);
}
