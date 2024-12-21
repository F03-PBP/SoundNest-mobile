import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:soundnest_mobile/discussions/forum_post.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<ForumPost>> fetchThreads() async {
    final response = await http.get(Uri.parse('${baseUrl}view_threads/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> threadsJson = data['threads'];
      return threadsJson.map((json) => ForumPost.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load threads');
    }
  }

  Future<ForumPost> createThread({
    required String title,
    required String content,
    int? productId,
    // required String csrfToken, // Omit if not needed
  }) async {
    final response = await http.post(
      Uri.parse('${baseUrl}create_thread/'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        // 'X-CSRFToken': csrfToken, // If CSRF is required
      },
      body: {
        'title': title,
        'content': content,
        if (productId != null) 'product_id': productId.toString(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return ForumPost.fromJson(data);
    } else {
      throw Exception('Failed to create thread: ${response.body}');
    }
  }

  Future<ForumPost> addComment({
    required int threadId,
    required String content,
    // required String csrfToken, // Omit if not needed
  }) async {
    final response = await http.post(
      Uri.parse('${baseUrl}add_comment/$threadId/'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest',
        // 'X-CSRFToken': csrfToken, // If CSRF is required
      },
      body: {
        'content': content,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return ForumPost.fromJson(data);
    } else {
      throw Exception('Failed to add comment: ${response.body}');
    }
  }

  // Implement other methods like toggleLike, repost, share, delete, edit, report as needed
}
