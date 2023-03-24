import 'dart:convert';

List<Lang> langFromJson(String str) =>
    List<Lang>.from(json.decode(str).map((x) => Lang.fromJson(x)));

String langToJson(List<Lang> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lang {
  Lang({
    required this.iso6391,
    required this.englishName,
    required this.name,
  });

  String iso6391;
  String englishName;
  String name;

  factory Lang.fromJson(Map<String, dynamic> json) => Lang(
        iso6391: json["iso_639_1"],
        englishName: json["english_name"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "iso_639_1": iso6391,
        "english_name": englishName,
        "name": name,
      };
}
