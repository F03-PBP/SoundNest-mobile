import 'package:flutter/material.dart';

// Review Card for Profile Page
class ReviewCard extends StatelessWidget {
  final String description;
  final int rating;
  final String productName;

  const ReviewCard({
    super.key,
    required this.description,
    required this.rating,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.headphones,
                    size: 24,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  productName.length > 20
                      ? '${productName.substring(0, 20)}...'
                      : productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Text overflow "..."
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Review Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),

            // Rating Stars
            Row(
              children: List.generate(10, (index) {
                if (index < rating) {
                  return const Icon(Icons.star,
                      color: Color(0xFFE7B66B), size: 20);
                } else {
                  return const Icon(Icons.star_border,
                      color: Colors.grey, size: 20);
                }
              }),
            ),
            const SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }
}
