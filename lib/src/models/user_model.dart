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

  /// Maps a `users/{uid}` Firestore document, tolerating both shapes that
  /// exist in production (OPEN_QUESTIONS Q2 = b):
  ///
  /// - current: `firstName` / `lastName` (Register_provider)
  /// - legacy:  `firstname` (full display name) / `lastname` ("")
  ///   written by the now-deleted `services/googleauth.dart`.
  ///
  /// Missing strings fall back to `''` instead of throwing a TypeError on the
  /// non-nullable fields. Nothing is renamed in the stored data.
  factory Users.fromFirestore(Map<String, dynamic> d) => Users(
        id: d['id'] as String?,
        email: _str(d['email']),
        firstName: _str(d['firstName'] ?? d['firstname']).trim(),
        lastName: _str(d['lastName'] ?? d['lastname']).trim(),
        ProfilePic: _str(d['ProfilePic']),
        role: _str(d['role'], fallback: 'User'),
        report: d['report'] as String?,
      );

  static String _str(Object? v, {String fallback = ''}) =>
      v is String ? v : fallback;

  /// Splits a Google display name into first / last.
  /// "Ada" -> ("Ada", ""), "Ada King Lovelace" -> ("Ada", "King Lovelace").
  /// The old code did `split(" ")[1]`, which threw a RangeError for one-word
  /// names *after* the Firebase sign-in succeeded, so no user document was
  /// ever written for those accounts.
  static ({String first, String last}) splitDisplayName(String? displayName) {
    final parts = (displayName ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return (first: '', last: '');
    return (first: parts.first, last: parts.skip(1).join(' '));
  }

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
