class ForumPost {
  final String id;
  final String author;
  final String content;
  final List<ForumPost> replies; // Mendukung balasan berjenjang
  final DateTime timestamp;

  ForumPost({
    required this.id,
    required this.author,
    required this.content,
    List<ForumPost>? replies,
    required this.timestamp,
  }) : replies = replies ?? <ForumPost>[];
}
