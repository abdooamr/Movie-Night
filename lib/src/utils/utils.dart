import 'package:Movie_Night/generated/l10n.dart';
import 'package:intl/intl.dart';

const imageUrl = 'https://image.tmdb.org/t/p/w500';

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
