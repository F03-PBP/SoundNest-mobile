import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double originalPrice;
  final double discountedPrice;
  final double rating;
  final int numRatings;
  final int discount;
  final String timeRemaining;
  

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.originalPrice,
    required this.discountedPrice,
    required this.rating,
    required this.numRatings,
    required this.discount,
    required this.timeRemaining,
  });

  String formatRupiah(double value) {
    // Convert the number to an integer for formatting without decimals
    final intValue = value.toInt();

    // Reverse the string representation of the number
    String reversed = intValue.toString().split('').reversed.join('');

    // Insert dots every three digits
    String withDots = '';
    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        withDots += '.';
      }
      withDots += reversed[i];
    }

    // Reverse again to get the final result
    return 'Rp${withDots.split('').reversed.join('')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 150.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          formatRupiah(discountedPrice),
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4), // Adjust spacing between discounted and original price if needed
                        Text(
                          formatRupiah(originalPrice),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$discount% Off',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '$rating ($numRatings)',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Sales ends in: $timeRemaining',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}