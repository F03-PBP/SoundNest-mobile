import 'package:flutter/material.dart';

class ReplyForm extends StatelessWidget {
  final String postId;
  final TextEditingController controller = TextEditingController();
  final Function(String, String) onReplyCreated;

  ReplyForm({super.key, required this.postId, required this.onReplyCreated});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reply'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Reply...'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              onReplyCreated(postId, controller.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Send'),
        ),
      ],
    );
  }
}
