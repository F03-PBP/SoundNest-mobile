import 'package:flutter/material.dart';

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
  final int _itemsPerPage = 6;

  // Dummy data list
  List<Map<String, dynamic>> _wishlistData = List.generate(30, (index) {
    return {
      'nama_produk': 'Product ${index + 1}',
      'jumlah': (index + 1) % 5 + 1,
      'price': (index + 1) * 100,
      'date_added': DateTime.now().subtract(Duration(days: index)),
    };
  });

  // Get the data for the current page
  List<Map<String, dynamic>> get _currentPageData {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return _wishlistData.sublist(startIndex, endIndex > _wishlistData.length ? _wishlistData.length : endIndex);
  }

  // Next Page
  void _nextPage() {
    if ((_currentPage * _itemsPerPage) < _wishlistData.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  // Previous Page
  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
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
          Expanded(
            child: ListView.builder(
              itemCount: _currentPageData.length,
              itemBuilder: (context, index) {
                var item = _currentPageData[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item['nama_produk']),
                    subtitle: Text('Quantity: ${item['jumlah']} | Price: ${item['price']}'),
                    trailing: Text('Added: ${item['date_added'].toString().split(' ')[0]}'),
                  ),
                );
              },
            ),
          ),
          // Pagination buttons
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
