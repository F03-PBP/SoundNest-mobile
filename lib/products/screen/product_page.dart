import 'package:flutter/material.dart';
import 'package:soundnest_mobile/products/screen/list_productentry.dart';
import 'package:soundnest_mobile/products/screen/productentry_form.dart'; // Import the ProductEntryForm

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  void _showSortOptions(
      BuildContext context, ValueNotifier<String> sortNotifier) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Filter Produk",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("Default"),
                onTap: () {
                  sortNotifier.value = "latest";
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Harga (Terendah ke Tertinggi)"),
                onTap: () {
                  sortNotifier.value = "price_asc";
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Harga (Tertinggi ke Terendah)"),
                onTap: () {
                  sortNotifier.value = "price_desc";
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> sortNotifier = ValueNotifier<String>("latest");

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondaryContainer,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 110, 16, 28),
            child: const Text(
              'Products',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () => _showSortOptions(context, sortNotifier),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the ProductEntryForm when the button is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductEntryForm(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 168, 115, 77),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Tambah Produk',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: sortNotifier,
              builder: (context, sortOption, _) {
                return ProductEntryCards(sortOption: sortOption);
              },
            ),
          ),
        ],
      ),
    );
  }
}
