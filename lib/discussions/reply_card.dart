import 'package:flutter/material.dart';
import 'forum_post.dart';

class ReplyCard extends StatelessWidget {
  final ForumPost reply;
  final Function(String, ForumPost) onReplyToReply;

  const ReplyCard({
    Key? key,
    required this.reply,
    required this.onReplyToReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 32.0, top: 8.0, bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(reply.author[0].toUpperCase()),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reply.author, style: const TextStyle(fontSize: 14)),
                    Text(
                      '${reply.timestamp.hour}h ago',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(reply.content, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _showReplyToReplyDialog(context, reply);
                },
                child: const Text('Reply'),
              ),
            ),
            if (reply.replies.isNotEmpty)
              Column(
                children: reply.replies.map((subReply) {
                  return ReplyCard(
                    reply: subReply,
                    onReplyToReply: onReplyToReply,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _showReplyToReplyDialog(BuildContext context, ForumPost parentReply) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reply to ${parentReply.author}'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Write your reply...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onReplyToReply(controller.text, parentReply);
                  Navigator.pop(context);
                }
              },
              child: const Text('Reply'),
            ),
          ],
        );
      },
    );
  }
}
