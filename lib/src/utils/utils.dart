import 'package:Movie_Night/generated/l10n.dart';
import 'package:intl/intl.dart';

const imageUrl = 'https://image.tmdb.org/t/p/w500';

const _tmdbImageBase = 'https://image.tmdb.org/t/p';

/// TMDB poster widths, smallest first.
const List<int> _tmdbPosterWidths = [92, 154, 185, 342, 500, 780];

/// URL of [path] at the smallest TMDB size that still covers 90% of
/// [physicalWidth] (device pixels). Falls back to the old `w500` when the
/// width is unknown, and caps at `w780`.
String tmdbImage(String path, double physicalWidth) {
  if (!physicalWidth.isFinite || physicalWidth <= 0) return '$imageUrl$path';
  final need = physicalWidth * 0.9;
  final width = _tmdbPosterWidths.firstWhere(
    (w) => w >= need,
    orElse: () => _tmdbPosterWidths.last,
  );
  return '$_tmdbImageBase/w$width$path';
}

/// TMDB backdrop widths, smallest first.
const List<int> _tmdbBackdropWidths = [300, 780, 1280];

/// URL of backdrop [path] at the smallest TMDB size that still covers 90% of
/// [physicalWidth]. A stretched `w500` looked soft on full-width headers.
String tmdbBackdrop(String path, double physicalWidth) {
  if (!physicalWidth.isFinite || physicalWidth <= 0) {
    return '$_tmdbImageBase/w780$path';
  }
  final need = physicalWidth * 0.9;
  final width = _tmdbBackdropWidths.firstWhere(
    (w) => w >= need,
    orElse: () => _tmdbBackdropWidths.last,
  );
  return '$_tmdbImageBase/w$width$path';
}

String? _cachedLocale;
Map<int, String>? _cachedGenres;

/// Genre names are locale-dependent (S.current.*), so the map is rebuilt only
/// when the active locale changes rather than on every call.
Map<int, String> _genreMap() {
  final loc = Intl.getCurrentLocale();
  if (_cachedGenres == null || _cachedLocale != loc) {
    _cachedLocale = loc;
    _cachedGenres = {
      28: S.current.Actiongenre,
      12: S.current.Adventuregenre,
      16: S.current.Animationgenre,
      35: S.current.Comedygenre,
      80: S.current.Crimegenre,
      99: S.current.Documentarygenre,
      18: S.current.Dramagenre,
      10751: S.current.Familygenre,
      14: S.current.Fantasygenre,
      36: S.current.Historygenre,
      27: S.current.Horrorgenre,
      10402: S.current.Musicgenre,
      9648: S.current.Mysterygenre,
      10749: S.current.Romancegenre,
      878: S.current.ScienceFictiongenre,
      10770: S.current.TVMoviegenre,
      53: S.current.Thrillergenre,
      10752: S.current.Wargenre,
      37: S.current.Westerngenre,
      10759: S.current.actiontvlabel,
      10762: S.current.kidstvlabel,
      10763: S.current.newstvlabel,
      10764: S.current.realitytvlabel,
      10765: S.current.scifitvlabel,
      10766: S.current.soaptvlabel,
      10767: S.current.talktvlabel,
      10768: S.current.wartvlabel,
    };
  }
  return _cachedGenres!;
}

String getGenres(List<int> genres) {
  final map = _genreMap();
  return genres.map((g) => map[g]).whereType<String>().join(', ');
}
