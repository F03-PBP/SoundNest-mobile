import 'package:flutter/material.dart';

class NewPostScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final Function(String) onPostCreated; // Callback untuk menambahkan posting

  NewPostScreen({Key? key, required this.onPostCreated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Posting Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Tulis sesuatu...'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onPostCreated(controller.text); // Panggil callback
                  Navigator.pop(context);
                }
              },
              child: const Text('Kirim'),
            ),
          ],
        ),
      ),
    );
  }
}
