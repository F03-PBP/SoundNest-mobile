import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soundnest_mobile/authentication/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:soundnest_mobile/widgets/toast.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double originalPrice;
  final double discountedPrice;
  final double rating;
  final int numRatings;
  final double discount;
  final String timeRemaining;
  final double maxWidth;
  final String id;
  final DateTime saleEndTime;
  final VoidCallback onDelete;

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
    required this.maxWidth,
    required this.id,
    required this.onDelete,
    required this.saleEndTime,
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
    final userModel = Provider.of<UserModel>(context);

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with fixed aspect ratio
          SizedBox(
            height: 190.0, // Adjust the height as per your needs
            width: double.infinity,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8.0)),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit
                        .contain, // This will ensure the entire image is visible without being cropped
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '$discount% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (userModel.isSuperuser)
                  Positioned(
                    bottom: 8.0,
                    right: 8.0,
                    child: Row(
                      children: [
                        // Edit Button
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: 16,
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                size: 16, color: Colors.white),
                            onPressed: () => _showEditModal(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Delete Button
                        CircleAvatar(
                          backgroundColor: Colors.red.withOpacity(0.8),
                          radius: 16,
                          child: IconButton(
                            icon: const Icon(Icons.delete,
                                size: 16, color: Colors.white),
                            onPressed: () => _showDeleteConfirmation(context),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Product details section with fixed padding
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      formatRupiah(discountedPrice),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      formatRupiah(originalPrice),
                      style: TextStyle(
                        fontSize: 12.0,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16.0),
                    Text(
                      ' $rating ($numRatings)',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Sales ends in: $timeRemaining',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.red,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: EditDealsForm(
          productId: id,
          discount: discount,
          saleEndTime: saleEndTime,
          onRefresh: onDelete,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product from Deals'),
        content: const Text(
            'Are you sure you want to remove this product from deals?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final response = await http.delete(
                  Uri.parse(
                      'http://localhost:8000/best-deals/delete-deals/$id/'),
                );

                if (response.statusCode == 200) {
                  if (context.mounted) {
                    Toast.success(context, 'Deal deleted successfully');
                    Navigator.pop(context); // Close dialog
                    onDelete();
                  }
                  // Refresh the deals list
                } else {
                  throw Exception('Failed to delete product');
                }
              } catch (e) {
                if (context.mounted) {
                  Toast.error(context, 'Error: $e');
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class EditDealsForm extends StatefulWidget {
  final String productId;
  final double discount;
  final DateTime saleEndTime;
  final VoidCallback onRefresh;

  const EditDealsForm({
    super.key,
    required this.productId,
    required this.discount,
    required this.saleEndTime,
    required this.onRefresh,
  });

  @override
  State<EditDealsForm> createState() => _EditDealsFormState();
}

class _EditDealsFormState extends State<EditDealsForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _discountController;
  late TextEditingController _endDateController;
  late TextEditingController _endTimeController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _endTimeController.text = picked.format(context);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Combine date and time
    final DateTime endDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime?.hour ?? 23,
      _selectedTime?.minute ?? 59,
    );

    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:8000/best-deals/edit-deals/${widget.productId}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'discount': int.parse(_discountController.text),
          'end_date': endDateTime.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pop(context);
          widget.onRefresh();
          Toast.success(context, 'Deal updated successfully');
        }
      } else {
        throw Exception('Failed to update deal');
      }
    } catch (e) {
      if (mounted) {
        Toast.error(context, 'Error updating deal: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Edit Deal',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _discountController,
            decoration: const InputDecoration(
              labelText: 'Discount Percentage',
              suffixText: '%',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a discount';
              }
              final discount = int.tryParse(value);
              if (discount == null || discount < 1 || discount > 99) {
                return 'Discount must be between 1 and 99';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _endDateController,
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an end date';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextFormField(
                  controller: _endTimeController,
                  decoration: const InputDecoration(
                    labelText: 'End Time',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an end time';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Update Deal',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Convert UTC time to local time
    final localSaleEndTime = widget.saleEndTime.toLocal();

    // Initialize the selected date and time from localSaleEndTime
    _selectedDate = localSaleEndTime;
    _selectedTime =
        TimeOfDay(hour: localSaleEndTime.hour, minute: localSaleEndTime.minute);

    // Initialize controllers
    _discountController =
        TextEditingController(text: widget.discount.toString());
    _endDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(localSaleEndTime));
    _endTimeController = TextEditingController(
        text:
            "${localSaleEndTime.hour.toString().padLeft(2, '0')}:${localSaleEndTime.minute.toString().padLeft(2, '0')}");
  }

  @override
  void dispose() {
    _discountController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }
}
