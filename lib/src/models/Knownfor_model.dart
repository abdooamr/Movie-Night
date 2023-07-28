// To parse this JSON data, do
//
//     final knownFor = knownForFromJson(jsonString);

import 'dart:convert';

KnownFor knownForFromJson(String str) => KnownFor.fromJson(json.decode(str));

String knownForToJson(KnownFor data) => json.encode(data.toJson());

class KnownFor {
  List<Cast> cast;
  List<Cast> crew;
  int id;

  KnownFor({
    required this.cast,
    required this.crew,
    required this.id,
  });

  factory KnownFor.fromJson(Map<String, dynamic> json) => KnownFor(
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
        "id": id,
      };
}

class Cast {
  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String? originalTitle;
  String? originalName;
  String? overview;
  double popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  String? name;
  bool? video;
  double voteAverage;
  int voteCount;
  String? character;
  String? creditId;
  int? order;
  Department? department;
  Job? job;

  Cast({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    this.character,
    required this.creditId,
    this.order,
    this.department,
    this.job,
    this.originalName,
    this.name,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalTitle:
            json["original_title"] == null ? null : json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        title: json["title"],
        video: json["video"] == null ? null : json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
        department: departmentValues.map[json["department"]] == null
            ? null
            : departmentValues.map[json["department"]]!,
        job: jobValues.map[json["job"]] == null
            ? null
            : jobValues.map[json["job"]]!,
        originalName:
            json["original_name"] == null ? null : json["original_name"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "character": character,
        "credit_id": creditId,
        "order": order,
        "department": departmentValues.reverse[department] == null
            ? null
            : departmentValues.reverse[department],
        "job": jobValues.reverse[job],
        "original_name": originalName == null ? null : originalName,
        "name": name == null ? null : name,
      };
}

enum Department { PRODUCTION }

final departmentValues = EnumValues({"Production": Department.PRODUCTION});

enum Job { ASSOCIATE_PRODUCER, PRODUCER, EXECUTIVE_PRODUCER }

final jobValues = EnumValues({
  "Associate Producer": Job.ASSOCIATE_PRODUCER,
  "Executive Producer": Job.EXECUTIVE_PRODUCER,
  "Producer": Job.PRODUCER
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
