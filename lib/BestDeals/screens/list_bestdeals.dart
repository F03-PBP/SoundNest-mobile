import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:soundnest_mobile/BestDeals/models/sale.dart';
import 'package:soundnest_mobile/BestDeals/widgets/product_card.dart';
import 'package:soundnest_mobile/BestDeals/screens/add_to_deals_page.dart'; // Add this import

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
    saleData = fetchSaleData();
  }

  Future<Sale> fetchSaleData() async {
    final response = await http.get(Uri.parse('http://localhost:8000/best-deals/json/'));

    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));
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

          final topPicks = snapshot.data!.topPicks;
          final leastCountdown = snapshot.data!.leastCountdown;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddToDealsPage(),
                        ),
                      ).then((_) {
                        // Refresh the deals list when returning from add page
                        setState(() {
                          saleData = fetchSaleData();
                        });
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Deals'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              const SectionHeader(title: 'Top Picks (sorted by rating)'),
              bestDealsGrid(topPicks),

              const SectionHeader(title: 'Least Countdown (sorted by time remaining)'),
              bestDealsGrid(leastCountdown),
            ],
          );
        },
      ),
    );
  }

  Widget bestDealsGrid(List<dynamic> productData) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: productData.length,
      itemBuilder: (context, index) {
        var item = productData[index];
        return ProductCard(
          imageUrl: 'http://127.0.0.1:8000/static/images/templateimage.webp',
          title: item.productName,
          originalPrice: item.originalPrice,
          discountedPrice: item.price,
          rating: item.rating,
          numRatings: item.reviews,
          discount: item.discount,
          timeRemaining: item.timeRemaining,
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

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