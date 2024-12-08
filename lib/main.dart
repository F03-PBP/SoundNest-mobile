import 'package:flutter/material.dart';
import 'discussions/forum_screen.dart'; // Pastikan path ini sesuai dengan struktur direktori Anda

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forum Diskusi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ForumScreen(),
    );
  }
}
