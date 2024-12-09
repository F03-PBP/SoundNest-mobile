import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String _username = '';
  bool _isSuperuser = false;
  String _initials = '';
  String _userToken = '';

  String get username => _username;
  bool get isSuperuser => _isSuperuser;
  String get initials => _initials;
  String get userToken => _userToken;

  void setUser(String username, bool isSuperuser, String userToken) {
    _username = username;
    _isSuperuser = isSuperuser;
    _initials = generateInitials(username);
    _userToken = userToken;
    notifyListeners();
  }

  // LOGOUT
  void logout() {
    _username = '';
    _isSuperuser = false;
    _initials = '';
    _userToken = '';
    notifyListeners();
  }

  // INITIALS
  String generateInitials(String name) {
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }
}
