import 'package:flutter/material.dart';

class NewPostScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final Function(String) onPostCreated;

  NewPostScreen({super.key, required this.onPostCreated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Thread'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration:
                  const InputDecoration(hintText: 'Write your thread...'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onPostCreated(controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
