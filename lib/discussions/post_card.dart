import 'package:flutter/material.dart';
import 'reply_card.dart';
import 'forum_post.dart';

class PostCard extends StatelessWidget {
  final String author;
  final String content;
  final DateTime timestamp;
  final VoidCallback onReply;
  final List<ForumPost> replies;
  final Function(String, ForumPost) onReplyToReply; 

  const PostCard({
    Key? key,
    required this.author,
    required this.content,
    required this.timestamp,
    required this.onReply,
    required this.replies,
    required this.onReplyToReply, 
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
            Text(author, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              '${timestamp.toLocal()}'.split(' ')[0],
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: onReply, child: const Text('Reply')),
            ),
            if (replies.isNotEmpty)
              ...replies.map(
                (reply) => ReplyCard(
                  reply: reply,
                  onReplyToReply: onReplyToReply, 
                ),
              ),
          ],
        ),
      ),
    );
  }
}
