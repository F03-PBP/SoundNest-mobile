import 'package:flutter/material.dart';
import '../forum_post.dart';

class RandomColorUtil {
  static Color getColorFromName(String name) {
    final int hash = name.hashCode;
    final int colorIndex = hash % Colors.primaries.length;
    return Colors.primaries[colorIndex];
  }
}

class ReplyCard extends StatelessWidget {
  final ForumPost reply;
  final ForumPost parentPost;
  final Function(ForumPost, ForumPost) onDelete;
  final Function(ForumPost) onLikeToggle;
  final Function(ForumPost) onRepost;
  final Function(ForumPost) onShare;
  final Function(String, ForumPost) onReplyToReply;
  final Function(ForumPost) onEdit;
  final bool isSuperuser;

  const ReplyCard({
    Key? key,
    required this.reply,
    required this.parentPost,
    required this.onDelete,
    required this.onLikeToggle,
    required this.onRepost,
    required this.onShare,
    required this.onReplyToReply,
    required this.onEdit,
    required this.isSuperuser,
  }) : super(key: key);

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
              title: const Text("Report Reply"),
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
                    print("Reported reasons: $selectedReasons");
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
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        RandomColorUtil.getColorFromName(reply.author),
                    child: Text(
                      reply.author[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reply.author, style: const TextStyle(fontSize: 14)),
                      Text(
                        '${reply.timestamp.hour}h ago',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
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
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => onEdit(reply),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => onDelete(parentPost, reply),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(reply.content, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      reply.likedByUser
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: reply.likedByUser ? Colors.red : null,
                    ),
                    onPressed: () => onLikeToggle(reply),
                  ),
                  Text('${reply.likes}', style: const TextStyle(fontSize: 12)),
                  IconButton(
                    icon: const Icon(Icons.reply),
                    onPressed: () => onReplyToReply(reply.id, reply),
                  ),
                  Text('${reply.replies.length}',
                      style: const TextStyle(fontSize: 12)),
                  IconButton(
                    icon: const Icon(Icons.repeat),
                    onPressed: () => onRepost(reply),
                  ),
                  Text('${reply.reposts}',
                      style: const TextStyle(fontSize: 12)),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => onShare(reply),
                  ),
                  Text('${reply.shares}', style: const TextStyle(fontSize: 12)),
                ],
              ),
              if (reply.replies.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    children: reply.replies.map((subReply) {
                      return ReplyCard(
                        reply: subReply,
                        parentPost: reply,
                        onDelete: onDelete,
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
      ),
    );
  }
}
