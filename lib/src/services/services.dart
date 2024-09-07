import 'package:Movie_Night/src/models/Knownfor_model.dart';
import 'package:Movie_Night/src/models/cast_model.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/models/video_prov_model.dart';
import 'package:http/http.dart' as http;
import 'package:Movie_Night/src/models/movie_model.dart' as movie;
import 'package:Movie_Night/src/models/video_model.dart';
import '../models/credit_model.dart';
import '../models/global_review_model.dart';

const baseUrl = 'https://api.themoviedb.org/3/';
var key = '?api_key=cc18b713f1ab56cfab6306f06b6c1b9d';
var video = "&append_to_response=videos";
var orginallangeng = "&with_original_language=en";
var egyptregion = "&with_origin_country=EG";
late String endPoint;

Future<movie.Model> getUpcomingMovies(String lang) async {
  endPoint = 'movie/upcoming';
  List<movie.Result> allResults = []; // Store all results from multiple pages

  for (int page = 1; page <= 5; page++) {
    final url = '$baseUrl$endPoint$key&page=$page&language=$lang';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      movie.Model model = movie.modelFromJson(response.body);
      allResults.addAll(model.results); // Append results from the current page
    } else {
      throw Exception('Failed to load genres');
    }
  }

  return movie.Model(
    page: 1, // Set the page value as needed
    results: allResults,
    totalPages: 500, // Update this value based on your requirement
    totalResults: allResults.length,
  );
}

Future<movie.Model> getTrending(bool isTvShow, String lang) async {
  endPoint = isTvShow ? 'trending/tv/day' : 'trending/movie/day';
  List<movie.Result> allResults = []; // Store all results from multiple pages

  for (int page = 1; page <= 5; page++) {
    final url = '$baseUrl$endPoint$key&page=$page&language=$lang';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      movie.Model model = movie.modelFromJson(response.body);
      allResults.addAll(model.results); // Append results from the current page
    } else {
      throw Exception('Failed to load genres');
    }
  }

  return movie.Model(
    page: 1, // Set the page value as needed
    results: allResults,
    totalPages: 500, // Update this value based on your requirement
    totalResults: allResults.length,
  );
}

Future<movie.Model> getPopular(bool isTvShow, String lang) async {
  endPoint = isTvShow ? 'tv/popular' : 'movie/popular';
  List<movie.Result> allResults = []; // Store all results from multiple pages

  for (int page = 1; page <= 5; page++) {
    final url = '$baseUrl$endPoint$key&page=$page&language=$lang';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      movie.Model model = movie.modelFromJson(response.body);
      allResults.addAll(model.results); // Append results from the current page
    } else {
      throw Exception('Failed to load popular');
    }
  }

  return movie.Model(
    page: 1, // Set the page value as needed
    results: allResults,
    totalPages: 5, // Update this value based on your requirement
    totalResults: allResults.length,
  );
}

// Future<Model> getPopularTvShows() async {
//   endPoint = 'tv/popular';
//   final url = '$baseUrl$endPoint$key';

//   final response = await http.get(Uri.parse(url));
//   if (response.statusCode == 200) {
//     return modelFromJson(response.body);
//   } else {
//     throw Exception('failed to load popular');
//   }
// }

// Future<movie.Model> getTopRatedMovies() async {
//   endPoint = 'movie/top_rated';
//   final String url = '$baseUrl$endPoint$key';
//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     return movie.modelFromJson(response.body);
//   } else {
//     throw Exception('failed to load top rated movies');
//   }
// }

Future<movie.Model> discoverMovies(
    {int? genreId, int? pageCount, String? lang}) async {
  endPoint = 'discover/movie';
  List<movie.Result> allResults = []; // Store all results from multiple pages

  for (int page = 1; page <= 5; page++) {
    final String url = genreId == null
        ? '$baseUrl$endPoint$key&page=$page'
        : '$baseUrl$endPoint$key&with_genres=$genreId&page=$page&language=$lang';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      movie.Model model = movie.modelFromJson(response.body);
      allResults.addAll(model.results); // Append results from the current page
    } else {
      throw Exception('Failed to load genres');
    }
  }

  return movie.Model(
    page: 1, // Set the page value as needed
    results: allResults,
    totalPages: 500, // Update this value based on your requirement
    totalResults: allResults.length,
  );
}

Future<Credit> getCredits(int id, bool isTvShow, String lang) async {
  endPoint = isTvShow ? 'tv/$id/credits' : 'movie/$id/credits';
  final String url = '$baseUrl$endPoint$key&language=$lang';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return creditFromJson(response.body);
  } else {
    throw Exception('failed to load credits');
  }
}

Future<movie.Model> getrecommendations(
    int id, bool isTvShow, String lang) async {
  endPoint = isTvShow ? 'tv/$id/recommendations' : 'movie/$id/recommendations';
  final String url = '$baseUrl$endPoint$key&language=$lang';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return movie.modelFromJson(response.body);
  } else {
    throw Exception('failed to load similar');
  }
}

Future<Review> getReviews(int id, bool isTvShow, String lang) async {
  endPoint = isTvShow ? 'tv/$id/reviews' : 'movie/$id/reviews';
  final String url = '$baseUrl$endPoint$key&language=$lang';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return reviewFromJson(response.body);
  } else {
    throw Exception('failed to load reviews');
  }
}

Future<movie.Model> movieSearch(String query, String lang) async {
  endPoint = 'search/tv';
  final url = '$baseUrl$endPoint$key&query=$query&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return movie.modelFromJson(response.body);
  } else {
    throw Exception('not found');
  }
}

Future<movie.Model> searchData(String query, String lang) async {
  endPoint = 'search/multi';
  final url = '$baseUrl$endPoint$key&query=$query&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return movie.modelFromJson(response.body);
  } else {
    throw Exception('not found');
  }
}

Future<Video> getyoutubeid(int id, bool isTvShow, String lang) async {
  //endPoint = 'movie/$id/videos';
  endPoint = isTvShow ? 'tv/$id/videos' : 'movie/$id/videos';
  final url = '$baseUrl$endPoint$key$video&language=$lang';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return videoFromJson(response.body);
  } else {
    throw Exception('failed to load video id');
  }
}

Future<Watchprovider?> getprovider(int id, bool isTvShow, String lang) async {
  endPoint = isTvShow ? 'tv/$id/watch/providers' : 'movie/$id/watch/providers';
  final url = '$baseUrl$endPoint$key$video&language=$lang';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return watchproviderFromJson(response.body);
  } else {
    throw Exception('failed to load Providers');
  }
}

Future<movie.Model> getEgyptionmovies(bool isTvShow, String lang) async {
  endPoint = isTvShow ? 'discover/tv' : 'discover/movie';
  List<movie.Result> allResults = []; // Store all results from multiple pages

  for (int page = 1; page <= 5; page++) {
    final url = '$baseUrl$endPoint$key$egyptregion&page=$page&language=$lang';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      movie.Model model = movie.modelFromJson(response.body);
      allResults.addAll(model.results); // Append results from the current page
    } else {
      throw Exception('Failed to load genres');
    }
  }

  return movie.Model(
    page: 1, // Set the page value as needed
    results: allResults,
    totalPages: 500, // Update this value based on your requirement
    totalResults: allResults.length,
  );
}

Future<movie.Model> getAiringToday(String lang) async {
  endPoint = 'tv/airing_today';
  final url = '$baseUrl$endPoint$key$orginallangeng&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return movie.modelFromJson(response.body);
  } else {
    throw Exception('failed to load trending');
  }
}

Future<MovieModel> getdetails(int id, bool isTvShow, String lang) async {
  endPoint = isTvShow ? 'tv/$id' : 'movie/$id';
  final url = '$baseUrl$endPoint$key&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return movieModelFromJson(response.body);
  } else {
    throw Exception('failed to load Details');
  }
}

Future<CastModel> getcastdetails(int id, String lang) async {
  endPoint = 'person/$id';
  final url = '$baseUrl$endPoint$key&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return castModelFromJson(response.body);
  } else {
    throw Exception('failed to load Details');
  }
}

Future<KnownFor> getcastknownfor(int id, bool isTvShow, String lang) async {
  endPoint = isTvShow ? 'person/$id/tv_credits' : 'person/$id/movie_credits';
  final url = '$baseUrl$endPoint$key&language=$lang';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return knownForFromJson(response.body);
  } else {
    throw Exception('failed to load Details');
  }
}
