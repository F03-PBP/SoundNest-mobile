import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:soundnest_mobile/authentication/models/user_model.dart';
import 'package:soundnest_mobile/products/models/product_entry.dart';
import 'package:soundnest_mobile/widgets/toast.dart';
import 'package:soundnest_mobile/products/screen/product_details.dart';
import 'package:soundnest_mobile/products/screen/editproduct_form.dart';

class ProductEntryCards extends StatefulWidget {
  final String sortOption;

  const ProductEntryCards({super.key, required this.sortOption});

  @override
  State<ProductEntryCards> createState() => _ProductEntryCardsState();
}

class _ProductEntryCardsState extends State<ProductEntryCards> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    try {
      final response = await request.get(
        'http://localhost:8000/api/products/?sort=${widget.sortOption}', // TODO: Ganti ke PWS
      );

      List<ProductEntry> listProduct = [];
      for (var d in response) {
        if (d != null) {
          listProduct.add(ProductEntry.fromJson(d));
        }
      }
      return listProduct;
    } catch (e) {
      return [];
    }
  }

  String formatPrice(String price) {
    if (price.length > 12) {
      return '${price.substring(0, 9)}...';
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final user = Provider.of<UserModel>(context);
    final List<String> imagePaths = [
      'assets/images/1.png',
      'assets/images/2.png',
      'assets/images/3.png',
      'assets/images/4.png',
      'assets/images/5.png',
      'assets/images/6.png',
      'assets/images/7.png',
      'assets/images/8.png',
      'assets/images/9.png',
      'assets/images/10.png',
    ];

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
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.5,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index].fields;
                    final imagePath = imagePaths[index % imagePaths.length];

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
                                  'Experience sound like never before with the ${product.productName} Headphones. Engineered for audiophiles and casual listeners alike, these headphones deliver immersive sound quality with deep bass, crisp highs, and a balanced midrange.',
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
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: 140,
                                ),
                              ),
                              const SizedBox(height: 8),
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
                                'Rp${formatPrice(product.price.toString())}',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
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
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: user.isSuperuser
                                    ? [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProductForm(
                                                  productId:
                                                      snapshot.data![index].pk,
                                                  productName:
                                                      product.productName,
                                                  price:
                                                      product.price.toDouble(),
                                                  rating:
                                                      product.rating.toDouble(),
                                                  reviews: product.reviews,
                                                  onProductUpdated: () {
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF362417),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () async {
                                            final bool confirmed =
                                                await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Konfirmasi Ulang"),
                                                  content: const Text(
                                                      "Apakah anda ingin menghapus produk ini?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, true),
                                                      child:
                                                          const Text("Delete"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirmed) {
                                              try {
                                                final response =
                                                    await request.postJson(
                                                  'http://localhost:8000/delete_flutter/${snapshot.data![index].pk}/', // TODO: Ganti ke PWS
                                                  jsonEncode({}),
                                                );

                                                if (context.mounted) {
                                                  if (response['status'] ==
                                                      "success") {
                                                    Toast.success(context,
                                                        "Product successfully deleted!");

                                                    setState(() {});
                                                  } else {
                                                    Toast.error(context,
                                                        "Error: ${response['message']}");
                                                  }
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  Toast.error(
                                                      context, "Error: $e");
                                                }
                                              }
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ]
                                    : [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF362417),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                              ),
                            ],
                          ),
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
