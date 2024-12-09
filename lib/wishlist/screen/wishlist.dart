import 'package:flutter/material.dart';
import 'package:soundnest_mobile/wishlist/screen/list_wishlist.dart';
import 'wishlist_card.dart';

void main() {
  runApp(MaterialApp(
    home: WishlistPage(),
  ));
}

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  int _currentPage = 1;
  final int _itemsPerPage = 4;

  List<Map<String, dynamic>> _wishlistData = List.generate(30, (index) {
    return {
      'id': index,
      'nama_produk': 'Product ${index + 1}',
      'jumlah': (index + 1) % 5 + 1,
      'price': (index + 1) * 100,
      'date_added': DateTime.now().subtract(Duration(days: index)),
    };
  });

  int get totalProduk =>
      _wishlistData.fold(0, (sum, item) => sum + item['jumlah'] as int);

  int get totalHarga =>
      _wishlistData.fold(0, (sum, item) => sum + (item['jumlah'] * item['price']) as int);

  List<Map<String, dynamic>> get _currentPageData {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return _wishlistData.sublist(startIndex, endIndex > _wishlistData.length ? _wishlistData.length : endIndex);
  }

  void _updateQuantity(int id, int newJumlah) {
    setState(() {
      final item = _wishlistData.firstWhere((item) => item['id'] == id);
      item['jumlah'] = newJumlah;
    });
  }

  void _addNewProduct(String name, int quantity, int price) {
    setState(() {
      _wishlistData.add({
        'id': _wishlistData.length,
        'nama_produk': name,
        'jumlah': quantity,
        'price': price,
        'date_added': DateTime.now(),
      });
    });
  }

  void _nextPage() {
    if ((_currentPage * _itemsPerPage) < _wishlistData.length) {
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

  void _openAddProductModal(BuildContext context) {
    String productName = '';
    int productQuantity = 1;
    int productPrice = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Product Name'),
                onChanged: (value) {
                  productName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  productQuantity = int.tryParse(value) ?? 1;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  productPrice = int.tryParse(value) ?? 0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (productName.isNotEmpty && productPrice > 0) {
                  _addNewProduct(productName, productQuantity, productPrice);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Wishlist'),
      ),
      body: Column(
        children: <Widget>[
          // Total Produk dan Harga
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Produk: $totalProduk', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Total Harga: $totalHarga', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => _openAddProductModal(context),
                        child: const Text('Add Product'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MoodEntryPage(),
                            ),
                          );
                        },
                        child: const Text('Go to Mood Entry'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _currentPageData.length,
              itemBuilder: (context, index) {
                var item = _currentPageData[index];
                return WishlistCard(
                  item: item,
                  onQuantityChanged: (newJumlah) =>
                      _updateQuantity(item['id'], newJumlah),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _previousPage,
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
