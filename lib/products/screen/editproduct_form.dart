import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:soundnest_mobile/widgets/toast.dart';

class EditProductForm extends StatefulWidget {
  final String productId;
  final String productName;
  final double price;
  final double rating;
  final int reviews;
  final VoidCallback onProductUpdated;

  const EditProductForm({
    super.key,
    required this.productId,
    required this.productName,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.onProductUpdated,
  });

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _productName;
  late double _price;
  late double _rating;
  late int _reviews;

  @override
  void initState() {
    super.initState();
    _productName = widget.productName;
    _price = widget.price;
    _rating = widget.rating;
    _reviews = widget.reviews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Produk"),
        leading: Transform.translate(
          offset: const Offset(12, 0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name Field
              TextFormField(
                initialValue: _productName,
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _productName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a product name.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price Field
              TextFormField(
                initialValue: _price.toString(),
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
                initialValue: _rating.toString(),
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
                initialValue: _reviews.toString(),
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

                    // Send updated data to the Django API
                    final response = await request.postJson(
                      "http://localhost:8000/edit_flutter/${widget.productId}/", // TODO: Ganti ke PWS
                      jsonEncode({
                        'product_name': _productName,
                        'price': _price.toString(),
                        'rating': _rating,
                        'reviews': _reviews.toString(),
                      }),
                    );

                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        Toast.success(context, "Product successfully updated!");

                        widget.onProductUpdated();

                        // Navigate back to the product list page
                        Navigator.pop(context);
                      } else {
                        Toast.error(context, "Error: ${response['error']}");
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF362417), // Button color
                  foregroundColor: Colors.white, // Text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Optional: Rounded corners
                  ),
                ),
                child: const Text("Update Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
