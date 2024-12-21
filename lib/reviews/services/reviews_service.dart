import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:soundnest_mobile/authentication/models/user_model.dart';
import 'package:soundnest_mobile/reviews/models/reviews_model.dart';

class ReviewsService {
  static const String baseUrl =
      'http://localhost:8000/reviews'; // TODO: Ganti ke PWS

  // ADD REVIEW
  static Future<Map<String, dynamic>> addReview(
      String productId,
      int? selectedRating,
      String reviewDescription,
      UserModel userModel) async {
    return (selectedRating == null || reviewDescription.isEmpty)
        ? _errorResponse('Please provide both rating and description')
        : _processResponse(
            await http.post(
              Uri.parse('$baseUrl/add/'),
              headers: _headers(userModel),
              body: jsonEncode({
                'rating': selectedRating,
                'description': reviewDescription,
                'product': productId,
              }),
            ),
          );
  }

  // EDIT REVIEW
  static Future<Map<String, dynamic>> editReview(
    String reviewId,
    int? selectedRating,
    String reviewDescription,
    UserModel userModel,
  ) async {
    return (selectedRating == null || reviewDescription.isEmpty)
        ? _errorResponse('Please provide both rating and description')
        : _processResponse(
            await http.post(
              Uri.parse('$baseUrl/edit/$reviewId/'),
              headers: _headers(userModel),
              body: jsonEncode({
                'rating': selectedRating,
                'description': reviewDescription,
              }),
            ),
          );
  }

  // DELETE REVIEW
  static Future<Map<String, dynamic>> deleteReview(
    String reviewId,
    UserModel userModel,
  ) async {
    return _processResponse(
      await http.delete(
        Uri.parse('$baseUrl/delete/$reviewId/'),
        headers: _headers(userModel),
      ),
    );
  }

  // LIST REVIEWS
  static Future<List<Review>> fetchReviews(
      {String? productId, bool byUser = false, UserModel? userModel}) async {
    final queryParams = {
      if (productId != null) 'product_id': productId,
      if (byUser) 'by_user': 'true',
    };

    final uri =
        Uri.http('localhost:8000', 'reviews/flutter/show_reviews', queryParams);

    // Review by user
    final Map<String, String> headers = (byUser && userModel != null)
        ? {'Authorization': 'Token ${userModel.userToken}'}
        : {};

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        try {
          List<dynamic> data = json.decode(response.body);

          return data.map((item) {
            return Review.fromJson(item);
          }).toList();
        } catch (e) {
          throw Exception('Failed to parse response body');
        }
      } else {
        throw Exception('Empty response body');
      }
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  static Map<String, String> _headers(UserModel userModel) => {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${userModel.userToken}',
      };

  static Map<String, dynamic> _processResponse(http.Response response) {
    final data = jsonDecode(response.body);
    return response.statusCode == 200 || response.statusCode == 201
        ? {'success': true, 'message': data['message']}
        : {'success': false, 'message': data['message']};
  }

  static Map<String, dynamic> _errorResponse(String message) => {
        'success': false,
        'message': message,
      };
}
