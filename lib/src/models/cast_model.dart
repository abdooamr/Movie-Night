// To parse this JSON data, do
//
//     final castModel = castModelFromJson(jsonString);

import 'dart:convert';

CastModel castModelFromJson(String str) => CastModel.fromJson(json.decode(str));

String castModelToJson(CastModel data) => json.encode(data.toJson());

class CastModel {
  bool? adult;
  String? biography;
  DateTime? birthday;
  DateTime? deathday;
  int? gender;
  dynamic homepage;
  int id;
  String? imdbId;
  String? knownForDepartment;
  String? name;
  String? placeOfBirth;
  double popularity;
  String? profilePath;

  CastModel({
    required this.adult,
    required this.biography,
    this.birthday,
    this.deathday,
    required this.gender,
    this.homepage,
    required this.id,
    required this.imdbId,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    required this.popularity,
    required this.profilePath,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) => CastModel(
        adult: json["adult"],
        biography: json["biography"] == null ? null : json["biography"],
        birthday:
            json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
        deathday:
            json["deathday"] == null ? null : DateTime.parse(json["deathday"]),
        gender: json["gender"],
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"],
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "biography": biography,
        "birthday": birthday == null
            ? null
            : "${birthday?.year.toString().padLeft(4, '0')}-${birthday?.month.toString().padLeft(2, '0')}-${birthday?.day.toString().padLeft(2, '0')}",
        "deathday": deathday,
        "gender": gender,
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "known_for_department": knownForDepartment,
        "name": name,
        "place_of_birth": placeOfBirth,
        "popularity": popularity,
        "profile_path": profilePath,
      };
}
