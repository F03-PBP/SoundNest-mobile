import 'package:flutter/material.dart';

class WishlistCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onQuantityChanged;

  const WishlistCard({Key? key, required this.item, required this.onQuantityChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        title: Text(item['nama_produk']),
        subtitle: Text('Quantity: ${item['jumlah']} | Price: \$${item['price']}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row to wrap the buttons to avoid vertical overflow
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: item['jumlah'] >= 10 ? Colors.grey : Colors.blue),
                  onPressed: item['jumlah'] >= 10 ? null : () {
                    onQuantityChanged(item['jumlah'] + 1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove, color: item['jumlah'] <= 1 ? Colors.grey : Colors.blue),
                  onPressed: item['jumlah'] <= 1 ? null : () {
                    onQuantityChanged(item['jumlah'] - 1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}