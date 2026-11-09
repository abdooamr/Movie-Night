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
    this.password,
  });
  String? id;
  String? password;
  String email;
  String firstName;
  String lastName;
  String ProfilePic;
  String role;
  String? report;
  factory Users.fromJson(Map<String, dynamic> json) => Users(
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        id: json["id"],
        ProfilePic: json["ProfilePic"],
        role: json["role"],
        report: json["report"],
        password: json["password"],
      );

  /// Maps a Supabase `profiles` row (snake_case columns). The email is not
  /// stored in `profiles`: pass it from auth for the signed-in user, or it
  /// comes in the row from `admin_list_users`. Missing strings fall back to
  /// `''` instead of throwing on the non-nullable fields.
  factory Users.fromRow(Map<String, dynamic> row, {String email = ''}) =>
      Users(
        id: row['id'] as String?,
        email: row['email'] is String ? row['email'] as String : email,
        firstName: _str(row['first_name']).trim(),
        lastName: _str(row['last_name']).trim(),
        ProfilePic: _str(row['profile_pic']),
        role: _str(row['role'], fallback: 'User'),
        report: row['report'] as String?,
      );

  static String _str(Object? v, {String fallback = ''}) =>
      v is String ? v : fallback;

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "ProfilePic": ProfilePic,
        "role": role,
        "report": report,
        "password": password,
      };
}
