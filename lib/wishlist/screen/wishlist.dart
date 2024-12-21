import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:soundnest_mobile/wishlist/screen/wishlist_form.dart';
import 'package:soundnest_mobile/wishlist/models/wishlist_model.dart';
import 'package:soundnest_mobile/widgets/toast.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  int _currentPage = 1;
  final int _itemsPerPage = 4;
  String _sortOption = "Price (asc)"; // Default sorting option

  // Fungsi untuk mengambil data produk wishlist dari Django
  Future<List<WishlistProduct>> fetchWishlist(CookieRequest request) async {
    final response = await request.get(
        'http://127.0.0.1:8000/wishlist/json/wishlist'); // TODO: Ganti ke PWS
    var data = response;
    List<WishlistProduct> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(WishlistProduct.fromJson(d));
      }
    }
    return listProduct;
  }

  // Fungsi untuk menghitung total produk
  int calculateTotalProduk(List<WishlistProduct> data) {
    return data.fold(0, (sum, item) => sum + item.fields.jumlah);
  }

  // Fungsi untuk menghitung total harga produk
  int calculateTotalHarga(List<WishlistProduct> data) {
    return data.fold(
        0, (sum, item) => sum + (item.fields.jumlah * item.fields.price));
  }

  // Fungsi untuk berpindah ke halaman berikutnya
  void _nextPage(List<WishlistProduct> data) {
    if ((_currentPage * _itemsPerPage) < data.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  // Fungsi untuk berpindah ke halaman sebelumnya
  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  // Fungsi untuk menyortir data wishlist
  List<WishlistProduct> _sortData(List<WishlistProduct> data) {
    List<WishlistProduct> sortedData = List.from(data);
    if (_sortOption == "Price (asc)") {
      sortedData.sort((a, b) => a.fields.price.compareTo(b.fields.price));
    } else if (_sortOption == "Quantity (asc)") {
      sortedData.sort((a, b) => a.fields.jumlah.compareTo(b.fields.jumlah));
    } else if (_sortOption == "Price (desc)") {
      sortedData.sort((a, b) => b.fields.price.compareTo(a.fields.price));
    } else if (_sortOption == "Quantity (desc)") {
      sortedData.sort((a, b) => b.fields.jumlah.compareTo(a.fields.jumlah));
    }
    return sortedData;
  }

  // Fungsi untuk menghapus produk dari wishlist berdasarkan ID
  Future<void> deleteProduct(CookieRequest request, String productId) async {
    final response = await request.post(
        'http://127.0.0.1:8000/wishlist/delete_flutter/',
        {'productId': productId}); // TODO: Ganti ke PWS
    if (response['status'] == 'success') {
      setState(() {}); // Menyegarkan tampilan setelah penghapusan
    } else {
      Toast.error(context, 'Failed to delete product');
    }
  }

  // Fungsi untuk mengedit quantity produk
  Future<void> editProductQuantity(
      CookieRequest request, String productId, int newQuantity) async {
    if (newQuantity < 0) {
      Toast.error(context, 'Quantity must be greater than or equal to 0');
      return;
    }

    // Mengirim request POST dengan JSON payload menggunakan postJson
    final response = await request.postJson(
      'http://127.0.0.1:8000/wishlist/edit_quantity_flutter/', // TODO: Ganti ke PWS
      jsonEncode({
        'product_id': productId,
        'new_quantity': newQuantity,
      }), // Mengirim data sebagai JSON
    );

    // Mengecek status response
    if (response['status'] == 'success') {
      setState(() {}); // Menyegarkan tampilan setelah pengeditan
    } else {
      // Menangani error jika pengeditan gagal
      Toast.error(context, 'Failed to update quantity');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: FutureBuilder(
        future: fetchWishlist(request),
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
              List<WishlistProduct> sortedData = _sortData(snapshot.data!);
              List<WishlistProduct> currentPageData = sortedData.sublist(
                (_currentPage - 1) * _itemsPerPage,
                (_currentPage * _itemsPerPage > sortedData.length)
                    ? sortedData.length
                    : _currentPage * _itemsPerPage,
              );

              int totalProduk = calculateTotalProduk(snapshot.data!);
              int totalHarga = calculateTotalHarga(snapshot.data!);

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Header Your Wishlist
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(32, 110, 16, 28),
                            child: const Text(
                              'Your Wishlist!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Bagian Add New Product dan Sort Option
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ProductEntryFormPage(),
                                      ),
                                    );
                                  },
                                  child: const Text('Add New Product'),
                                ),
                                DropdownButton<String>(
                                  value: _sortOption,
                                  items: [
                                    "Price (asc)",
                                    "Quantity (asc)",
                                    "Price (desc)",
                                    "Quantity (desc)"
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: value, child: Text(value));
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _sortOption = newValue!;
                                    });
                                  },
                                  dropdownColor: Colors.white,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(),
                                ),
                              ],
                            ),
                          ),

                          // Total Produk dan Total Harga
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text('Total Produk: $totalProduk',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 16),
                                Text('Total Harga: $totalHarga',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Daftar Produk
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap:
                                true, // Agar tidak mengganggu SingleChildScrollView
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 16.0),
                            itemCount: currentPageData.length,
                            itemBuilder: (_, index) => Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              padding: const EdgeInsets.all(16.0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Gambar produk
                                  SizedBox(
                                    height: 120,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                      child: Image.asset(
                                        'assets/images/9.png',
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Nama Produk
                                  Text(
                                    currentPageData[index].fields.namaProduk,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  // Harga Produk
                                  Text(
                                    'Price: \$${currentPageData[index].fields.price}',
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // Jumlah Produk
                                  Text(
                                    'Quantity: ${currentPageData[index].fields.jumlah}',
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  // Tombol Edit dan Delete
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          deleteProduct(
                                              request,
                                              currentPageData[index]
                                                  .pk
                                                  .toString());
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.brown),
                                        onPressed: () {
                                          int currentQuantity =
                                              currentPageData[index]
                                                  .fields
                                                  .jumlah;
                                          TextEditingController
                                              quantityController =
                                              TextEditingController(
                                                  text: currentQuantity
                                                      .toString());

                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title:
                                                  const Text('Edit Quantity'),
                                              content: TextField(
                                                controller: quantityController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            'New Quantity'),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    int newQuantity = int.parse(
                                                        quantityController
                                                            .text);
                                                    editProductQuantity(
                                                        request,
                                                        currentPageData[index]
                                                            .pk
                                                            .toString(),
                                                        newQuantity);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Save'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tombol Previous dan Next
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _previousPage,
                          child: const Text('Previous'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _nextPage(snapshot.data!),
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
