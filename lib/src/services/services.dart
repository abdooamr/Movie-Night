import 'dart:convert';

import 'package:Movie_Night/src/models/provider_model.dart';
import 'package:Movie_Night/src/models/tvshow_model.dart';
import 'package:http/http.dart' as http;
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/models/video_model.dart';
//import 'package:Movie_Night/secret.dart';

import '../models/credit_model.dart';
import '../models/review_model.dart';

const baseUrl = 'https://api.themoviedb.org/3/';
var key = '?api_key=cc18b713f1ab56cfab6306f06b6c1b9d';
var video = "&append_to_response=videos";
late String endPoint;

Future<Model> getUpcomingMovies() async {
  endPoint = 'movie/upcoming';
  final url = '$baseUrl$endPoint$key';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load trending');
  }
}

Future<Model> getTrendingMovies() async {
  endPoint = 'trending/all/day';
  final url = '$baseUrl$endPoint$key';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load trending');
  }
}

Future<Model> getPopularMovies() async {
  endPoint = 'movie/popular';
  final url = '$baseUrl$endPoint$key';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load popular');
  }
}

Future<Tvshows> getPopularTvShows() async {
  endPoint = 'tv/popular';
  final url = '$baseUrl$endPoint$key';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return tvshowsFromJson(response.body);
  } else {
    throw Exception('failed to load popular');
  }
}

Future<Model> getTopRatedMovies() async {
  endPoint = 'movie/top_rated';
  final String url = '$baseUrl$endPoint$key';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load top rated movies');
  }
}

Future<Model> discoverMovies({int? genreId}) async {
  endPoint = 'discover/movie';
  final String url = genreId == null
      ? '$baseUrl$endPoint$key'
      : '$baseUrl$endPoint$key&with_genres=$genreId';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load genres');
  }
}

Future<Credit> getCredits(int id, bool isTvShow) async {
  endPoint = isTvShow ? 'tv/$id/credits' : 'movie/$id/credits';
  final String url = '$baseUrl$endPoint$key';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return creditFromJson(response.body);
  } else {
    throw Exception('failed to load credits');
  }
}

Future<Model> getrecommendations(int id, bool isTvShow) async {
  endPoint = isTvShow ? 'tv/$id/recommendations' : 'movie/$id/recommendations';
  final String url = '$baseUrl$endPoint$key';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load similar');
  }
}

Future<Review> getReviews(int id, bool isTvShow) async {
  endPoint = isTvShow ? 'tv/$id/reviews' : 'movie/$id/reviews';
  final String url = '$baseUrl$endPoint$key';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return reviewFromJson(response.body);
  } else {
    throw Exception('failed to load reviews');
  }
}

Future<Model> movieSearch(String query) async {
  endPoint = 'search/movie';
  final url = '$baseUrl$endPoint$key&query=$query';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('not found');
  }
}

Future<Model> searchData(String query) async {
  endPoint = 'search/multi';
  final url = '$baseUrl$endPoint$key&query=$query';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('not found');
  }
}

Future<Model> getlanguages() async {
  endPoint = 'configuration/languages';
  final url = '$baseUrl$endPoint$key';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load popular');
  }
}

Future<Video> getyoutubeid(int id, bool isTvShow) async {
  //endPoint = 'movie/$id/videos';
  endPoint = isTvShow ? 'tv/$id/videos' : 'movie/$id/videos';
  final url = '$baseUrl$endPoint$key$video';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return videoFromJson(response.body);
  } else {
    throw Exception('failed to load video id');
  }
}

Future<Watchprovider?> getprovider(int id, bool isTvShow) async {
  endPoint = isTvShow ? 'tv/$id/watch/providers' : 'movie/$id/watch/providers';
  final url = '$baseUrl$endPoint$key$video';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return watchproviderFromJson(response.body);
  } else {
    throw Exception('failed to load Providers');
  }
}
