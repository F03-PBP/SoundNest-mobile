import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:soundnest_mobile/products/models/product_entry.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_details.dart'; // Import the ProductDetailsPage

class ProductEntryCards extends StatefulWidget {
  final String sortOption;

  const ProductEntryCards({super.key, required this.sortOption});

  @override
  State<ProductEntryCards> createState() => _ProductEntryCardsState();
}

class _ProductEntryCardsState extends State<ProductEntryCards> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    try {
      // Send the sort option as a query parameter
      final response = await request.get(
        'http://localhost:8000/api/products/?sort=${widget.sortOption}',
      );

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
              'Belum ada data Produk.',
              style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
            ),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index].fields;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(
                              productId: snapshot.data![index].pk,
                              productName: product.productName,
                              price: product.price.toDouble(),
                              rating: product.rating.toDouble(),
                              reviews: product.reviews,
                              description:
                                  'Experience sound like never before with the ${product.productName} Headphones. Engineered for audiophiles and casual listeners alike, these headphones deliver immersive sound quality with deep bass, crisp highs, and a balanced midrange. Featuring advanced noise-cancellation technology, you can escape the hustle and bustle of your surroundings and dive into your music, podcasts, or calls without distractions.',
                            ),
                          ),
                        );
                      },
                      child: Container(
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
                            SizedBox(
                              height:
                                  146, // Adjust height to make the image bigger
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  child: Image.asset(
                                    'assets/images/templateimage.png',
                                    fit:
                                        BoxFit.contain, // Keep the aspect ratio
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0,
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 4),
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
                                      fontSize: 18,
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
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .end, // Align icons to the right
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Implement edit functionality here
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(
                                              10), // Increase padding for larger size
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF362417),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20, // Increase icon size
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              12), // Space between Edit and Delete icons
                                      GestureDetector(
                                        onTap: () {
                                          // Implement delete functionality here
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(
                                              10), // Increase padding for larger size
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 20, // Increase icon size
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
