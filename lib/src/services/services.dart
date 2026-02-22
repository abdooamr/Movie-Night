import 'package:Movie_Night/src/models/Knownfor_model.dart';
import 'package:Movie_Night/src/models/cast_model.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/models/video_prov_model.dart';
import 'package:http/http.dart' as http;
import 'package:Movie_Night/src/models/movie_model.dart' as movie;
import 'package:Movie_Night/src/models/video_model.dart';
import '../models/credit_model.dart';
import '../models/global_review_model.dart';

const String baseUrl = 'https://api.themoviedb.org/3/';
const String key = '?api_key=cc18b713f1ab56cfab6306f06b6c1b9d';
const String video = "&append_to_response=videos";
const String orginallangeng = "&with_original_language=en";
const String egyptregion = "&with_origin_country=EG";

// NOTE: Removed global mutable endPoint. Use local `final` endpoint in each function.

Future<movie.Model> getUpcomingMovies(String lang) async {
  final String endPoint = 'movie/upcoming';
  final List<movie.Result> allResults = [];

  for (int page = 1; page <= 5; page++) {
    final String url = '$baseUrl$endPoint$key&page=$page&language=$lang';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final movie.Model model = movie.modelFromJson(response.body);
      allResults.addAll(model.results);
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  return movie.Model(
    page: 1,
    results: allResults,
    totalPages: 5,
    totalResults: allResults.length,
  );
}

Future<movie.Model> getTrending(bool isTvShow, String lang) async {
  final String endPoint = isTvShow ? 'trending/tv/day' : 'trending/movie/day';
  final List<movie.Result> allResults = [];

  for (int page = 1; page <= 5; page++) {
    final String url = '$baseUrl$endPoint$key&page=$page&language=$lang';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final movie.Model model = movie.modelFromJson(response.body);
      allResults.addAll(model.results);
    } else {
      throw Exception('Failed to load trending');
    }
  }

  return movie.Model(
    page: 1,
    results: allResults,
    totalPages: 5,
    totalResults: allResults.length,
  );
}

Future<movie.Model> getPopular(bool isTvShow, String lang) async {
  final String endPoint = isTvShow ? 'tv/popular' : 'movie/popular';
  final List<movie.Result> allResults = [];

  for (int page = 1; page <= 5; page++) {
    final String url = '$baseUrl$endPoint$key&page=$page&language=$lang';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final movie.Model model = movie.modelFromJson(response.body);
      allResults.addAll(model.results);
    } else {
      throw Exception('Failed to load popular');
    }
  }

  return movie.Model(
    page: 1,
    results: allResults,
    totalPages: 5,
    totalResults: allResults.length,
  );
}

Future<movie.Model> discoverMovies({
  int? genreId,
  int? pageCount,
  String? lang,
}) async {
  final String endPoint = 'discover/movie';
  final List<movie.Result> allResults = [];

  // NOTE: you currently ignore `pageCount`; keeping behavior the same (always 5 pages).
  for (int page = 1; page <= 5; page++) {
    final String url = genreId == null
        ? '$baseUrl$endPoint$key&page=$page'
        : '$baseUrl$endPoint$key&with_genres=$genreId&page=$page&language=$lang';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final movie.Model model = movie.modelFromJson(response.body);
      allResults.addAll(model.results);
    } else {
      throw Exception('Failed to load genres');
    }
  }

  return movie.Model(
    page: 1,
    results: allResults,
    totalPages: 5,
    totalResults: allResults.length,
  );
}

Future<Credit> getCredits(int id, bool isTvShow, String lang) async {
  final String endPoint = isTvShow ? 'tv/$id/credits' : 'movie/$id/credits';
  final String url = '$baseUrl$endPoint$key&language=$lang';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return creditFromJson(response.body);
  } else {
    throw Exception('Failed to load credits');
  }
}

Future<movie.Model> getrecommendations(
    int id, bool isTvShow, String lang) async {
  final String endPoint =
      isTvShow ? 'tv/$id/recommendations' : 'movie/$id/recommendations';
  final String url = '$baseUrl$endPoint$key&language=$lang';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return movie.modelFromJson(response.body);
  } else {
    throw Exception('Failed to load similar');
  }
}

Future<Review> getReviews(int id, bool isTvShow, String lang) async {
  final String endPoint = isTvShow ? 'tv/$id/reviews' : 'movie/$id/reviews';
  final String url = '$baseUrl$endPoint$key&language=$lang';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return reviewFromJson(response.body);
  } else {
    throw Exception('Failed to load reviews');
  }
}

Future<movie.Model> movieSearch(String query, String lang) async {
  final String endPoint = 'search/tv';
  final String url = '$baseUrl$endPoint$key&query=$query&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return movie.modelFromJson(response.body);
  } else {
    throw Exception('Not found');
  }
}

Future<movie.Model> searchData(String query, String lang) async {
  final String endPoint = 'search/multi';
  final String url = '$baseUrl$endPoint$key&query=$query&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return movie.modelFromJson(response.body);
  } else {
    throw Exception('Not found');
  }
}

Future<Video> getyoutubeid(int id, bool isTvShow, String lang) async {
  final String endPoint = isTvShow ? 'tv/$id/videos' : 'movie/$id/videos';
  final String url = '$baseUrl$endPoint$key$video&language=$lang';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return videoFromJson(response.body);
  } else {
    throw Exception('Failed to load video id');
  }
}

Future<Watchprovider?> getprovider(int id, bool isTvShow, String lang) async {
  final String endPoint =
      isTvShow ? 'tv/$id/watch/providers' : 'movie/$id/watch/providers';
  final String url = '$baseUrl$endPoint$key$video&language=$lang';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return watchproviderFromJson(response.body);
  } else {
    throw Exception('Failed to load Providers');
  }
}

Future<movie.Model> getEgyptionmovies(bool isTvShow, String lang) async {
  final String endPoint = isTvShow ? 'discover/tv' : 'discover/movie';
  final List<movie.Result> allResults = [];

  for (int page = 1; page <= 5; page++) {
    final String url =
        '$baseUrl$endPoint$key$egyptregion&page=$page&language=$lang';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final movie.Model model = movie.modelFromJson(response.body);
      allResults.addAll(model.results);
    } else {
      throw Exception('Failed to load genres');
    }
  }

  return movie.Model(
    page: 1,
    results: allResults,
    totalPages: 5,
    totalResults: allResults.length,
  );
}

Future<movie.Model> getAiringToday(String lang) async {
  final String endPoint = 'tv/airing_today';
  final String url = '$baseUrl$endPoint$key$orginallangeng&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return movie.modelFromJson(response.body);
  } else {
    throw Exception('Failed to load trending');
  }
}

Future<MovieModel> getdetails(int id, bool isTvShow, String lang) async {
  final String endPoint = isTvShow ? 'tv/$id' : 'movie/$id';
  final String url = '$baseUrl$endPoint$key&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return movieModelFromJson(response.body);
  } else {
    throw Exception('Failed to load Details');
  }
}

Future<CastModel> getcastdetails(int id, String lang) async {
  final String endPoint = 'person/$id';
  final String url = '$baseUrl$endPoint$key&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return castModelFromJson(response.body);
  } else {
    throw Exception('Failed to load Details');
  }
}

Future<KnownFor> getcastknownfor(int id, bool isTvShow, String lang) async {
  final String endPoint =
      isTvShow ? 'person/$id/tv_credits' : 'person/$id/movie_credits';
  final String url = '$baseUrl$endPoint$key&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return knownForFromJson(response.body);
  } else {
    throw Exception('Failed to load Details');
  }
}
