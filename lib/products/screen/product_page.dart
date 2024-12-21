import 'package:flutter/material.dart';
import 'package:soundnest_mobile/products/screen/list_productentry.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4), // Light background for the page
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brown Section
          Container(
            width: double.infinity,
            color: const Color(0xFF362417), // Brown background color
            padding: const EdgeInsets.fromLTRB(24, 110, 16, 28), // Add padding
            child: const Text(
              'Products',
              style: TextStyle(
                color: Colors.white, // White text color
                fontSize: 32, // Large font size
                fontWeight: FontWeight.bold, // Bold font
              ),
            ),
          ),
          // Categories Section with Tune Icon and Tambah Produk Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tune Icon
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    // Add functionality here
                  },
                ),
                // Tambah Produk Button
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for the "Tambah Produk" button
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF362417), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Tambah Produk',
                    style: TextStyle(
                      color: Colors.white, // Button text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Cards Section
          Expanded(
            child: ProductEntryCards(), // Displays product cards
          ),
        ],
      ),
    );
  }
}
