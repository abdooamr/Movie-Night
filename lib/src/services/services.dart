// Compatibility shims over [TmdbRepository] (task 2.5).
//
// Every function here forwards to `TmdbRepository.instance`, so all existing
// call sites get the shared HTTP client, timeout + retry, typed
// [TmdbException]s and the memory/disk cache without being rewritten at once.
// New code should use `TmdbRepository` directly; screens migrate one at a time.
//
// These deliberately return the repository's Future unchanged (no `async`
// wrapper) so a cached call yields the *same* Future instance and a
// FutureBuilder rebuilt with it does not flash back to its loading state.

import 'package:Movie_Night/src/data/tmdb_repository.dart';
import 'package:Movie_Night/src/models/Knownfor_model.dart';
import 'package:Movie_Night/src/models/cast_model.dart';
import 'package:Movie_Night/src/models/credit_model.dart';
import 'package:Movie_Night/src/models/global_review_model.dart';
import 'package:Movie_Night/src/models/movie_model.dart' as movie;
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/models/video_model.dart';
import 'package:Movie_Night/src/models/video_prov_model.dart';

export 'package:Movie_Night/src/data/tmdb_client.dart'
    show TmdbException, TmdbErrorKind;

TmdbRepository get _repo => TmdbRepository.instance;

/// Runs [fetch] with the TMDB caches bypassed (pull-to-refresh).
Future<T> refreshing<T>(Future<T> Function() fetch) => _repo.refresh(fetch);

Future<movie.Model> getUpcomingMovies(String lang) =>
    _repo.upcomingMovies(lang);

Future<movie.Model> getTrending(bool isTvShow, String lang) =>
    _repo.trending(isTvShow, lang);

Future<movie.Model> getPopular(bool isTvShow, String lang) =>
    _repo.popular(isTvShow, lang);

Future<movie.Model> discoverMovies({
  int? genreId,
  int? pageCount,
  String? lang,
}) =>
    _repo.discoverMovies(genreId: genreId, pageCount: pageCount, lang: lang);

Future<Credit> getCredits(int id, bool isTvShow, String lang) =>
    _repo.credits(id, isTvShow, lang);

Future<movie.Model> getrecommendations(int id, bool isTvShow, String lang) =>
    _repo.recommendations(id, isTvShow, lang);

Future<Review> getReviews(int id, bool isTvShow, String lang) =>
    _repo.reviews(id, isTvShow, lang);

Future<movie.Model> movieSearch(String query, String lang) =>
    _repo.searchTv(query, lang);

Future<movie.Model> searchData(String query, String lang,
        {bool seriesOnly = true}) =>
    _repo.searchMulti(query, lang, seriesOnly: seriesOnly);

Future<Video> getyoutubeid(int id, bool isTvShow, String lang) =>
    _repo.videos(id, isTvShow, lang);

Future<Watchprovider?> getprovider(int id, bool isTvShow, String lang) =>
    _repo.watchProviders(id, isTvShow, lang);

Future<movie.Model> getEgyptionmovies(bool isTvShow, String lang) =>
    _repo.egyptianTitles(isTvShow, lang);

Future<movie.Model> getAiringToday(String lang) => _repo.airingToday(lang);

Future<MovieModel> getdetails(int id, bool isTvShow, String lang) =>
    _repo.details(id, isTvShow, lang);

Future<CastModel> getcastdetails(int id, String lang) => _repo.person(id, lang);

Future<KnownFor> getcastknownfor(int id, bool isTvShow, String lang) =>
    _repo.personCredits(id, isTvShow, lang);
