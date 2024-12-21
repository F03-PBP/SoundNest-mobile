import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductEntryForm extends StatefulWidget {
  final VoidCallback onProductAdded;

  const ProductEntryForm({Key? key, required this.onProductAdded})
      : super(key: key);

  @override
  State<ProductEntryForm> createState() => _ProductEntryFormState();
}

class _ProductEntryFormState extends State<ProductEntryForm> {
  final _formKey = GlobalKey<FormState>();
  late String _productName;
  late double _price;
  late double _rating;
  late int _reviews;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _productName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a product.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the price.";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Rating Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Rating",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _rating = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a rating.";
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 1 || rating > 10) {
                    return "Please enter a rating between 1 and 10.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Reviews Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Reviews",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _reviews = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the number of reviews.";
                  }
                  if (int.tryParse(value) == null) {
                    return "Please enter a valid integer.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Send data to the Django API
                    final response = await request.postJson(
                      "http://localhost:8000/create_flutter/",
                      jsonEncode({
                        'name': _productName,
                        'price': _price.toString(),
                        'rating': _rating,
                        'reviews': _reviews.toString(),
                      }),
                    );

                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Product successfully created!"),
                          ),
                        );

                        widget.onProductAdded();

                        // Navigate back to the product list page
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: ${response['message']}"),
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF362417), // Button color #362417
                  foregroundColor: Colors.white, // Text color white
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Optional: Rounded corners
                  ),
                ),
                child: const Text("Tambah Produk"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
