import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel with ChangeNotifier {
  String _username = '';
  bool _isSuperuser = false;
  String _initials = '';
  String _userToken = '';

  String get username => _username;
  bool get isSuperuser => _isSuperuser;
  String get initials => _initials;
  String get userToken => _userToken;
  bool get isLoggedIn => _userToken.isNotEmpty;

  void setUser(String username, bool isSuperuser, String userToken) {
    _username = username;
    _isSuperuser = isSuperuser;
    _initials = generateInitials(username);
    _userToken = userToken;
    saveUser();
    notifyListeners();
  }

  // LOGOUT
  void logout() {
    _username = '';
    _isSuperuser = false;
    _initials = '';
    _userToken = '';
    clearUser();
    notifyListeners();
  }

  // INITIALS
  String generateInitials(String name) {
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }

  Future<void> saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _username);
    await prefs.setBool('isSuperuser', _isSuperuser);
    await prefs.setString('userToken', _userToken);
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    // Get data dari SharedPreferences
    _username = prefs.getString('username') ?? '';
    _isSuperuser = prefs.getBool('isSuperuser') ?? false;
    _userToken = prefs.getString('userToken') ?? '';
    _initials = generateInitials(_username);

    // Call notifyListeners jika token valid
    // notifyListeners = menghubungkan perubahan data dengan UI agar diperbarui secara otomatis.
    if (_userToken.isNotEmpty) {
      notifyListeners();
    }
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
