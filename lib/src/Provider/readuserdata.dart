import 'package:flutter/material.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/models/user_model.dart';

/// Profile reads and name edits for the UI, over [UserRepository]. The
/// picture upload lives in `ProfilePic`.
class UserData extends ChangeNotifier {
  final UserRepository _users = UserRepository.instance;

  Stream<Users?> getUserDataStream(String uid) => _users.userStream(uid);

  Future<void> updateuser(String firstname, String lastname) async {
    await _users.updateNames(firstName: firstname, lastName: lastname);
    notifyListeners();
  }
}
