// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.ProfilePic,
    required this.role,
    this.report,
  });
  String? id;
  String email;
  String firstName;
  String lastName;
  String ProfilePic;
  String role;
  String? report;
  factory Users.fromJson(Map<String, dynamic> json) => Users(
        email: json["email"],
        firstName: json["first name"],
        lastName: json["last name"],
        id: json["id"],
        ProfilePic: json["ProfilePic"],
        role: json["role"],
        report: json["report"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first name": firstName,
        "last name": lastName,
        "ProfilePic": ProfilePic,
        "role": role,
        "report": report,
      };
}
