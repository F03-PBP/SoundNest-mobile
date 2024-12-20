import 'package:flutter/material.dart';
import '../forum_post.dart';
import 'reply_card.dart';

class RandomColorUtil {
  static Color getColorFromName(String name) {
    final int hash = name.hashCode;
    final int colorIndex = hash % Colors.primaries.length;
    return Colors.primaries[colorIndex];
  }
}

class PostCard extends StatelessWidget {
  final ForumPost post;
  final Function(String) onReply;
  final Function(String, ForumPost) onReplyToReply;
  final Function(ForumPost) onLikeToggle;
  final Function(ForumPost) onRepost;
  final Function(ForumPost) onShare;
  final Function(ForumPost) onDelete;
  final Function(ForumPost) onEdit;
  final Function(ForumPost, ForumPost) onDeleteReply;
  final Function(ForumPost) onReport;
  final bool isSuperuser;

  const PostCard({
    Key? key,
    required this.post,
    required this.onReply,
    required this.onReplyToReply,
    required this.onLikeToggle,
    required this.onRepost,
    required this.onShare,
    required this.onDelete,
    required this.onEdit,
    required this.onDeleteReply,
    required this.onReport,
    required this.isSuperuser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      RandomColorUtil.getColorFromName(post.author),
                  child: Text(
                    post.author[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.author, style: const TextStyle(fontSize: 16)),
                    Text(
                      '${post.timestamp.hour}h ago',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'report') {
                      onReport(post);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'report',
                      child: Text('Report'),
                    ),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
                if (isSuperuser)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => onEdit(post),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDelete(post),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.likedByUser ? Icons.favorite : Icons.favorite_border,
                    color: post.likedByUser ? Colors.red : null,
                  ),
                  onPressed: () => onLikeToggle(post),
                ),
                Text('${post.likes}', style: const TextStyle(fontSize: 12)),
                IconButton(
                  icon: const Icon(Icons.reply),
                  onPressed: () => onReply(post.id),
                ),
                Text('${post.replies.length}',
                    style: const TextStyle(fontSize: 12)),
                IconButton(
                  icon: const Icon(Icons.repeat),
                  onPressed: () => onRepost(post),
                ),
                Text('${post.reposts}', style: const TextStyle(fontSize: 12)),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => onShare(post),
                ),
                Text('${post.shares}', style: const TextStyle(fontSize: 12)),
              ],
            ),
            if (post.replies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: post.replies.map((reply) {
                    return ReplyCard(
                      reply: reply,
                      parentPost: post,
                      onDelete: onDeleteReply,
                      onLikeToggle: onLikeToggle,
                      onRepost: onRepost,
                      onShare: onShare,
                      onReplyToReply: onReplyToReply,
                      onEdit: onEdit,
                      onReport: onReport,
                      isSuperuser: isSuperuser,
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
