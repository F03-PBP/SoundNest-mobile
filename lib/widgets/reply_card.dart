import 'package:flutter/material.dart';

class ReplyCard extends StatelessWidget {
  final String author;
  final String content;
  final DateTime timestamp;

  const ReplyCard({
    super.key,
    required this.author,
    required this.content,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 32.0, top: 8.0, bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(author, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(content, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            Text(
              '${timestamp.toLocal()}'.split(' ')[0],
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
