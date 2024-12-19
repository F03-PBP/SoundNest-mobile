import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:soundnest_mobile/BestDeals/models/sale.dart';
import 'package:soundnest_mobile/BestDeals/widgets/product_card.dart';


class BestDealsPage extends StatefulWidget {
  const BestDealsPage({super.key});

  @override
  State<BestDealsPage> createState() => _BestDealsPageState();
}

class _BestDealsPageState extends State<BestDealsPage> {
  late Future<Sale> saleData;

  @override
  void initState() {
    super.initState();
    saleData = fetchSaleData();  // Fetch the sale data from the API
  }

  Future<Sale> fetchSaleData() async {
    final response = await http.get(Uri.parse('http://localhost:8000/best-deals/json/'));

    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));  // Parse the JSON response
    } else {
      throw Exception('Failed to load sale data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Deals'),
      ),
      body: FutureBuilder<Sale>(
        future: saleData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          // Extract the top picks and least countdown from the fetched data
          final topPicks = snapshot.data!.topPicks;
          final leastCountdown = snapshot.data!.leastCountdown;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Section: Top Picks
              const SectionHeader(title: 'Top Picks (sorted by rating)'),
              bestDealsGrid(topPicks),

              // Section: Least Countdown
              const SectionHeader(title: 'Least Countdown (sorted by time remaining)'),
              bestDealsGrid(leastCountdown),
            ],
          );
        },
      ),
    );
  }

  // Create the grid layout for displaying products
  Widget bestDealsGrid(List<dynamic> productData) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: productData.length,
      itemBuilder: (context, index) {
        // For each product, cast the dynamic item to SaleItem
        var item = productData[index];
        return ProductCard(
          imageUrl: 'http://127.0.0.1:8000/static/images/templateimage.webp', // Ensure imageUrl is available in the model
          title: item.productName,
          originalPrice: item.originalPrice,
          discountedPrice: item.price,
          rating: item.rating,
          numRatings: item.reviews,
          discount: item.discount,
          timeRemaining: item.timeRemaining,  // Format and pass time
        );
      },
      shrinkWrap: true, // Prevent infinite scroll in nested grids
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

// Header for sections
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
