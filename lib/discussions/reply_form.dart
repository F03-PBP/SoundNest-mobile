import 'package:flutter/material.dart';

class ReplyForm extends StatelessWidget {
  final String postId;
  final TextEditingController controller = TextEditingController();
  final Function(String, String) onReplyCreated;

  ReplyForm({Key? key, required this.postId, required this.onReplyCreated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Balas Postingan'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Tulis balasan...'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              onReplyCreated(postId, controller.text); 
              Navigator.pop(
                  context); 
            }
          },
          child: const Text('Kirim'),
        ),
      ],
    );
  }
}
