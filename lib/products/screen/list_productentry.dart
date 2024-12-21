import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:soundnest_mobile/products/models/product_entry.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductEntryCards extends StatefulWidget {
  const ProductEntryCards({super.key});

  @override
  State<ProductEntryCards> createState() => _ProductEntryCardsState();
}

class _ProductEntryCardsState extends State<ProductEntryCards> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    try {
      // Ini nanti diubah aja pas udh push pws yg updated
      final response = await request.get('http://localhost:8000/api/products/');

      // For debugging
      print('API Response: $response');

      List<ProductEntry> listProduct = [];
      for (var d in response) {
        if (d != null) {
          listProduct.add(ProductEntry.fromJson(d));
        }
      }
      return listProduct;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder(
      future: fetchProducts(request),
      builder: (context, AsyncSnapshot<List<ProductEntry>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada data produk.',
              style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
            ),
          );
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index].fields;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(
                            16.0), // Add padding around the image
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(
                                  16)), // Rounded corners for the image
                          child: Image.asset(
                            'assets/images/templateimage.png', // Replace with actual product image URL
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp${product.price}',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${product.rating}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              Text(
                                ' (${product.reviews} reviews)',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed: () {
                            // Add product to cart functionality
                          },
                          icon:
                              const Icon(Icons.add_circle, color: Colors.brown),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
