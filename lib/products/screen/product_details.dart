import 'package:flutter/material.dart';
import 'package:soundnest_mobile/reviews/screen/reviews.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  final String productName;
  final double price;
  final double rating;
  final int reviews;
  final String description;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        leading: Transform.translate(
          offset: const Offset(12, 0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {
                // Add to wishlist functionality
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 32.0, right: 32.0, top: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gallery Section
              SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        children: [
                          Image.asset('assets/images/image1.png',
                              fit: BoxFit.contain, width: double.infinity),
                          Image.asset('assets/images/image2.png',
                              fit: BoxFit.contain, width: double.infinity),
                          Image.asset('assets/images/image3.png',
                              fit: BoxFit.contain, width: double.infinity),
                        ],
                      ),
                    ),
                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedBuilder(
                          animation: pageController,
                          builder: (context, _) {
                            final currentPage = pageController.page ?? 0;
                            final isActive = (currentPage.round() == index);
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 4, top: 28, right: 4),
                              width: isActive ? 12 : 8,
                              height: isActive ? 12 : 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? const Color.fromARGB(255, 51, 37, 32)
                                    : Colors.grey[400],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Product Info Section
              Text(
                productName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rp${price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '| $reviews customer reviews',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 110, 110, 110),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description Section
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 44),

              // Reviews Section
              ReviewsPage(productId: productId),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
