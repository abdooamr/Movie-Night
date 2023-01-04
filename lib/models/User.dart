// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  String uid;
  String email;
  String firstName;
  String lastName;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        uid: json["UID"],
        email: json["email"],
        firstName: json["first name"],
        lastName: json["last name"],
      );

  Map<String, dynamic> toJson() => {
        "UID": uid,
        "email": email,
        "first name": firstName,
        "last name": lastName,
      };
}
