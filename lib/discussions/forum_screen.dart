import 'package:flutter/material.dart';
import 'forum_post.dart';
import 'reply_card.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List<ForumPost> posts = [
    ForumPost(
      id: '1',
      author: 'tobi',
      content:
          'There are so many great little design touches in threads. Really Great',
      timestamp: DateTime.now().subtract(const Duration(hours: 7)),
      replies: [
        ForumPost(
          id: '1-1',
          author: 'h1brd',
          content:
              'you can start with @rourkey and @brainsw but there\'s more folks ❤️',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ],
    ),
    ForumPost(
      id: '2',
      author: 'jack',
      content: 'We wanted flying cars, instead we got 7 Twitter clones.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 33)),
    ),
    ForumPost(
      id: '3',
      author: 'mosseri',
      content:
          'Here we go. We have lots of work to do, but we\'re looking to build an open, civil place for people to have conversations.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 33)),
    ),
  ];

  void _addReply(String postId, String replyContent) {
    setState(() {
      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        posts[postIndex].replies.add(
              ForumPost(
                id: DateTime.now().toString(),
                author: 'Replier',
                content: replyContent,
                timestamp: DateTime.now(),
              ),
            );
      }
    });
  }

  void _addReplyToReply(String content, ForumPost parentReply) {
    setState(() {
      parentReply.replies.add(
        ForumPost(
          id: DateTime.now().toString(),
          author: 'Nested Replier',
          content: content,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _showReplyDialog(ForumPost post) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reply to Post'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter your reply'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addReply(post.id, controller.text);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Diskusi'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostCard(post);
        },
      ),
    );
  }

  Widget _buildPostCard(ForumPost post) {
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
                  child: Text(post.author[0].toUpperCase()),
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
              ],
            ),
            const SizedBox(height: 8),
            Text(post.content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            if (post.replies.isNotEmpty)
              Column(
                children: post.replies.map((reply) {
                  return ReplyCard(
                    reply: reply,
                    onReplyToReply: (content, parentReply) {
                      _addReplyToReply(content, parentReply);
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${post.replies.length} replies • 112 likes',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.reply),
                      onPressed: () {
                        _showReplyDialog(post);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
