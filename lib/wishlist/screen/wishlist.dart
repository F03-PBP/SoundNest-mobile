import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:soundnest_mobile/wishlist/screen/wishlist_form.dart';
import '/wishlist/models/wishlist_model.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  int _currentPage = 1;
  final int _itemsPerPage = 4;

  Future<List<WishlistProduct>> fetchMood(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/wishlist/json/wishlist');
    var data = response;
    List<WishlistProduct> listMood = [];
    for (var d in data) {
      if (d != null) {
        listMood.add(WishlistProduct.fromJson(d));
      }
    }
    return listMood;
  }

  int calculateTotalProduk(List<WishlistProduct> data) {
    return data.fold(0, (sum, item) => sum + item.fields.jumlah);
  }

  int calculateTotalHarga(List<WishlistProduct> data) {
    return data.fold(0, (sum, item) => sum + (item.fields.jumlah * item.fields.price));
  }

  void _nextPage(List<WishlistProduct> data) {
    if ((_currentPage * _itemsPerPage) < data.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Wishlist!'),
      ),
      body: FutureBuilder(
        future: fetchMood(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Belum ada data product pada SoundNest.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              List<WishlistProduct> currentPageData = snapshot.data!.sublist(
                (_currentPage - 1) * _itemsPerPage,
                (_currentPage * _itemsPerPage > snapshot.data!.length)
                    ? snapshot.data!.length
                    : _currentPage * _itemsPerPage,
              );

              int totalProduk = calculateTotalProduk(snapshot.data!);
              int totalHarga = calculateTotalHarga(snapshot.data!);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Produk: $totalProduk',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Total Harga: $totalHarga',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentPageData.length,
                      itemBuilder: (_, index) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${currentPageData[index].fields.namaProduk}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("${currentPageData[index].fields.dateAdded}"),
                            const SizedBox(height: 10),
                            Text("Jumlah: ${currentPageData[index].fields.jumlah}"),
                            const SizedBox(height: 10),
                            Text("Harga: ${currentPageData[index].fields.price}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _previousPage,
                        child: const Text('Previous'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => _nextPage(snapshot.data!),
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }
          }
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProductEntryFormPage()),
          );
        },
        child: const Text('Add New Product'),
      ),
    );
  }
}
