import 'package:flutter/material.dart';

import 'package:soundnest_mobile/discussions/forum_post.dart';
import 'package:soundnest_mobile/discussions/widgets/reply_card.dart';

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
    super.key,
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
  });

  void _showReportDialog(BuildContext context) {
    final List<String> reasons = [
      "Bahasa tidak senonoh",
      "Spam",
      "Konten tidak relevan",
      "Pelanggaran aturan komunitas"
    ];
    final List<bool> isSelected = List.filled(reasons.length + 1, false);
    final TextEditingController otherReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Report Thread"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(reasons.length, (index) {
                      return CheckboxListTile(
                        title: Text(reasons[index]),
                        value: isSelected[index],
                        onChanged: (value) {
                          setState(() {
                            isSelected[index] = value!;
                          });
                        },
                      );
                    }),
                    CheckboxListTile(
                      title: const Text("Other"),
                      value: isSelected.last,
                      onChanged: (value) {
                        setState(() {
                          isSelected[isSelected.length - 1] = value!;
                        });
                      },
                    ),
                    if (isSelected.last)
                      TextField(
                        controller: otherReasonController,
                        decoration: const InputDecoration(
                          labelText: "Explain other reason",
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    List<String> selectedReasons = [];
                    for (int i = 0; i < reasons.length; i++) {
                      if (isSelected[i]) {
                        selectedReasons.add(reasons[i]);
                      }
                    }
                    if (isSelected.last) {
                      selectedReasons
                          .add("Other: ${otherReasonController.text}");
                    }
                    //print("Reported reasons: $selectedReasons");
                    onReport(post);
                    Navigator.pop(context);
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar, author, timestamp, and menu
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
                      _showReportDialog(context);
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
                        icon: const Icon(Icons.edit, color: Colors.brown),
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
            // If thread has title, show it
            if (post.title.isNotEmpty)
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            if (post.title.isNotEmpty) const SizedBox(height: 4),
            Text(post.content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            // Action buttons: like, reply, repost, share
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
            // Display replies
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
