import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String _username = '';
  bool _isSuperuser = false;

  String get username => _username;
  bool get isSuperuser => _isSuperuser;

  void setUser(String username, bool isSuperuser) {
    _username = username;
    _isSuperuser = isSuperuser;
    notifyListeners();
  }
}
