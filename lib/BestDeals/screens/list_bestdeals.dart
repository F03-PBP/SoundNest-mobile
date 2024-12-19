import 'package:flutter/material.dart';
import 'package:soundnest_mobile/BestDeals/widgets/product_card.dart';

class BestDealsPage extends StatefulWidget {
  const BestDealsPage({super.key});

  @override
  State<BestDealsPage> createState() => _BestDealsPageState();
}

class ProductData {
    final String imageUrl;
    final String title;
    final double originalPrice;
    final double discountedPrice;
    final double rating;
    final int numRatings;

    ProductData({
      required this.imageUrl,
      required this.title,
      required this.originalPrice,
      required this.discountedPrice,
      required this.rating,
      required this.numRatings,
    });
  }
  
class _BestDealsPageState extends State<BestDealsPage> {
  // Define the product data

  // Create a list of dummy product data
  final List<ProductData> dummyProductData = [
    ProductData(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Product 1',
      originalPrice: 5099.0,
      discountedPrice: 3549.0,
      rating: 4.5,
      numRatings: 100,
    ),
    ProductData(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Product 2',
      originalPrice: 4799.0,
      discountedPrice: 3299.0,
      rating: 4.2,
      numRatings: 80,
    ),
    ProductData(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Product 3',
      originalPrice: 6499.0,
      discountedPrice: 4999.0,
      rating: 4.8,
      numRatings: 120,
    ),
    ProductData(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Product 4',
      originalPrice: 3999.0,
      discountedPrice: 2799.0,
      rating: 4.3,
      numRatings: 60,
    ),
    ProductData(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Product 5',
      originalPrice: 7999.0,
      discountedPrice: 6499.0,
      rating: 4.6,
      numRatings: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Deals'),
      ),
      body: bestDealsGrid(),
    );
  }

  // Create the grid layout
   Widget bestDealsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: dummyProductData.length,
      itemBuilder: (context, index) {
        return ProductCard(
          imageUrl: dummyProductData[index].imageUrl,
          title: dummyProductData[index].title,
          originalPrice: dummyProductData[index].originalPrice,
          discountedPrice: dummyProductData[index].discountedPrice,
          rating: dummyProductData[index].rating,
          numRatings: dummyProductData[index].numRatings,
          onAddToCart: () {
              // Add to cart logic here
          },
        );
      },
      padding: const EdgeInsets.all(16.0),
    );
  }
}