import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000/auth/flutter";

  // LOGIN
  static Future<Map<String, dynamic>> loginUser(
      CookieRequest request, String username, String password) async {
    try {
      final response = await request.login('$baseUrl/login/', {
        'username': username,
        'password': password,
      });

      if (request.loggedIn) {
        return {
          'success': true,
          'data': response,
          'message': 'Login Successful!',
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Login Failed.',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'An error occurred during login. Please try again later.',
      };
    }
  }

  // REGISTER
  static Future<Map<String, dynamic>> registerUser(CookieRequest request,
      String username, String password1, String password2) async {
    try {
      final response = await request.postJson(
        '$baseUrl/register/',
        jsonEncode({
          "username": username,
          "password1": password1,
          "password2": password2,
        }),
      );
      if (response['status'] == 'success') {
        return {
          'success': true,
          'message': 'Successfully registered!',
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Registration failed.',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message':
            'An error occurred during registration. Please try again later.',
      };
    }
  }

  // LOGOUT
  static Future<bool> logoutUser(CookieRequest request) async {
    try {
      await request.logout('$baseUrl/logout/');
      return true;
    } catch (error) {
      return false;
    }
  }
}
