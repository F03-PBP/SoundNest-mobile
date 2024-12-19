import 'package:flutter/material.dart';
import 'package:soundnest_mobile/BestDeals/screens/list_bestdeals.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Best Deals'),
        ),
        body: const BestDealsPage(),
      ),
    );
  }
}