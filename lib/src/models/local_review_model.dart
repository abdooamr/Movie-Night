// To parse this JSON data, do
//
//     final Localreviews = LocalreviewsFromJson(jsonString);

import 'dart:convert';

Localreviews LocalreviewsFromJson(String str) =>
    Localreviews.fromJson(json.decode(str));

String LocalreviewsToJson(Localreviews data) => json.encode(data.toJson());

class Localreviews {
  Localreviews({
    required this.review,
    required this.email,
    required this.displayname,
    required this.ProfilePic,
    required this.createdat,
    required this.id,
  });
  String? review;
  String email;
  String displayname;
  String ProfilePic;
  String createdat;
  String id;
  factory Localreviews.fromJson(Map<String, dynamic> json) => Localreviews(
        review: json["review"],
        email: json["email"],
        displayname: json["displayname"],
        ProfilePic: json["ProfilePic"],
        createdat: json["createdat"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "review": review,
        "email": email,
        "displayname": displayname,
        "ProfilePic": ProfilePic,
        "createdat": createdat,
        "id": id,
      };
}
