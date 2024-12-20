import 'package:flutter/material.dart';
import 'package:soundnest_mobile/products/screen/list_productentry.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.brown,
      ),
      body:
          const ProductEntryCards(), // Calls the product cards from list_productentry.dart
    );
  }
}
