class ForumPost {
  final String id;
  final String author;
  final String title; // Applicable for threads
  String content;
  final List<ForumPost> replies;
  final DateTime timestamp;
  int likes;
  bool likedByUser;
  int reposts;
  int shares;

  ForumPost({
    required this.id,
    required this.author,
    this.title = '', // Default empty for comments
    required this.content,
    List<ForumPost>? replies,
    required this.timestamp,
    this.likes = 0,
    this.likedByUser = false,
    this.reposts = 0,
    this.shares = 0,
  }) : replies = replies ?? <ForumPost>[];

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'].toString(),
      author: json['author'] ?? 'Unknown', // Adjust based on your backend
      title: json['title'] ?? '',
      content: json['content'],
      timestamp: DateTime.parse(json['created_at']),
      likes: json['likes'] ?? 0,
      likedByUser: json['likedByUser'] ?? false,
      reposts: json['reposts'] ?? 0,
      shares: json['shares'] ?? 0,
      replies: json['comments'] != null
          ? List<ForumPost>.from(
              json['comments'].map((comment) => ForumPost.fromJson(comment)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'content': content,
      'created_at': timestamp.toIso8601String(),
      'likes': likes,
      'likedByUser': likedByUser,
      'reposts': reposts,
      'shares': shares,
      'comments': replies.map((reply) => reply.toJson()).toList(),
    };
  }
}
