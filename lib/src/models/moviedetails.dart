// To parse this JSON data, do
//
//     final movieModel = movieModelFromJson(jsonString);

import 'dart:convert';

MovieModel movieModelFromJson(String str) =>
    MovieModel.fromJson(json.decode(str));

String movieModelToJson(MovieModel data) => json.encode(data.toJson());

class MovieModel {
  bool adult;
  String? backdropPath;
  int? budget;
  List<Genre> genres;
  String homepage;
  int id;
  String? imdbId;
  String? originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  DateTime? releaseDate;
  int? revenue;
  int? runtime;
  String? status;
  String? tagline;
  String? title;
  bool? video;
  double voteAverage;
  int voteCount;
  String? name;
  int? numberOfEpisodes;
  int? numberOfSeasons;
  DateTime? firstAirDate;

  MovieModel(
      {required this.adult,
      required this.backdropPath,
      required this.budget,
      required this.genres,
      required this.homepage,
      required this.id,
      required this.imdbId,
      required this.originalTitle,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.releaseDate,
      required this.revenue,
      required this.runtime,
      required this.status,
      required this.tagline,
      required this.title,
      required this.video,
      required this.voteAverage,
      required this.voteCount,
      required this.name,
      required this.numberOfEpisodes,
      required this.numberOfSeasons,
      required this.firstAirDate});

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        budget: json["budget"],
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"] == null
            ? null
            : DateTime.parse(json["release_date"]),
        revenue: json["revenue"],
        runtime: json["runtime"],
        status: json["status"],
        tagline: json["tagline"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        name: json["name"].toString(),
        firstAirDate: json["first_air_date"] == null
            ? null
            : DateTime.parse(json["first_air_date"]),
        numberOfEpisodes: json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "budget": budget,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate == null
            ? null
            : "${releaseDate?.year.toString().padLeft(4, '0')}-${releaseDate?.month.toString().padLeft(2, '0')}-${releaseDate?.day.toString().padLeft(2, '0')}",
        "revenue": revenue,
        "runtime": runtime,
        "status": status,
        "tagline": tagline,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "name": name,
        "first_air_date": firstAirDate == null
            ? null
            : "${firstAirDate?.year.toString().padLeft(4, '0')}-${firstAirDate?.month.toString().padLeft(2, '0')}-${firstAirDate?.day.toString().padLeft(2, '0')}",
        "number_of_episodes": numberOfEpisodes,
        "number_of_seasons": numberOfSeasons,
      };
}

class Genre {
  int id;
  String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
