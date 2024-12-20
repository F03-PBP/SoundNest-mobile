class ForumPost {
  final String id;
  final String author;
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
    required this.content,
    List<ForumPost>? replies,
    required this.timestamp,
    this.likes = 0,
    this.likedByUser = false,
    this.reposts = 0,
    this.shares = 0,
  }) : replies = replies ?? <ForumPost>[];
}
