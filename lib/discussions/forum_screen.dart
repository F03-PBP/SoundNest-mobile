import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:soundnest_mobile/discussions/forum_post.dart';
import 'package:soundnest_mobile/discussions/widgets/post_card.dart';
import 'package:soundnest_mobile/authentication/models/user_model.dart';
import 'package:soundnest_mobile/widgets/toast.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class RandomColorUtil {
  static Color getColorFromName(String name) {
    final int hash = name.hashCode;
    final int colorIndex = hash % Colors.primaries.length;
    return Colors.primaries[colorIndex];
  }
}

class _ForumScreenState extends State<ForumScreen> {
  List<ForumPost> posts = [
    ForumPost(
      id: '1',
      author: 'tobi',
      content: 'Does anyone know how good the Simgot EW200 is for IEMs?',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 46,
      reposts: 3,
      shares: 5,
      replies: [
        ForumPost(
          id: '1-1',
          author: 'h1brd',
          content: 'Start with @rourkey and @brainsw ❤️',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        ),
      ],
    ),
    ForumPost(
      id: '2',
      author: 'jack',
      content: 'Can anyone recommend a good TWS? I need it for running.',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      likes: 61,
      reposts: 1,
      shares: 28,
    ),
  ];

  void _addReply(String postId, String replyContent, String username) {
    setState(() {
      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        posts[postIndex].replies.add(
              ForumPost(
                id: DateTime.now().toString(),
                author: username,
                content: replyContent,
                timestamp: DateTime.now(),
              ),
            );
      }
    });
  }

  void _addReplyToReply(
      String content, ForumPost parentReply, String username) {
    setState(() {
      parentReply.replies.add(
        ForumPost(
          id: DateTime.now().toString(),
          author: username,
          content: content,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _toggleLike(ForumPost post) {
    setState(() {
      post.likedByUser = !post.likedByUser;
      post.likedByUser ? post.likes++ : post.likes--;
    });
  }

  void _repostThread(ForumPost post) {
    setState(() {
      post.reposts++;
    });
    Toast.success(context, 'Reposted thread by ${post.author}');
  }

  void _shareThread(ForumPost post) {
    setState(() {
      post.shares++;
    });
    Toast.success(context, 'Shared thread by ${post.author}');
  }

  void _deletePost(ForumPost post) {
    setState(() {
      posts.remove(post);
    });
    Toast.success(context, 'Thread by ${post.author} deleted');
  }

  void _deleteReply(ForumPost parentPost, ForumPost reply) {
    setState(() {
      parentPost.replies.remove(reply);
    });
    Toast.success(context, 'Reply by ${reply.author} deleted');
  }

  void _editPost(ForumPost post) {
    final controller = TextEditingController(text: post.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Thread'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Edit thread...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  post.content = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // void _editReply(ForumPost reply) {
  //   final controller = TextEditingController(text: reply.content);
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Edit'),
  //         content: TextField(
  //           controller: controller,
  //           decoration: const InputDecoration(hintText: 'Edit the reply...'),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               setState(() {
  //                 reply.content = controller.text;
  //               });
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Save'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _reportPost(ForumPost post) {
    Toast.success(context, 'Reported thread by ${post.author}');
  }

  // void _reportReply(ForumPost reply) {
  //   Toast.success(context, 'Reported reply by ${reply.author}');
  // }

  void _showReplyDialog(String postId, String username) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reply to the thread'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Write your reply...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addReply(postId, controller.text, username);
                  Navigator.pop(context);
                }
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showReplyToReplyDialog(ForumPost parentReply, String username) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reply ${parentReply.author}'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Write your reply...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addReplyToReply(controller.text, parentReply, username);
                  Navigator.pop(context);
                }
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showNewPostDialog(String username) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add threads'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(hintText: 'Write your thoughts...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addNewPost(controller.text, username);
                  Navigator.pop(context);
                }
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  void _addNewPost(String content, String username) {
    setState(() {
      posts.add(
        ForumPost(
          id: DateTime.now().toString(),
          author: username,
          content: content,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  Widget _buildPostCard(ForumPost post, String username, bool isSuperuser) {
    return PostCard(
      post: post,
      onReply: (postId) {
        _showReplyDialog(postId, username);
      },
      onReplyToReply: (content, parentReply) {
        _showReplyToReplyDialog(parentReply, username);
      },
      onLikeToggle: _toggleLike,
      onRepost: _repostThread,
      onShare: _shareThread,
      onDelete: (post) => _deletePost(post),
      onEdit: (post) => _editPost(post),
      onDeleteReply: _deleteReply,
      onReport: _reportPost,
      isSuperuser: isSuperuser,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final username = userModel.username;
    final isSuperuser = userModel.isSuperuser;
    //print("Logged in as: $username, Is Superuser: $isSuperuser");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          'Discussion Forums',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => _showNewPostDialog(username),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  size: 28,
                  color: Colors.brown,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostCard(post, username, isSuperuser);
        },
      ),
    );
  }
}
