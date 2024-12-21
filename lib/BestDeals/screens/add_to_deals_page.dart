import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:soundnest_mobile/BestDeals/models/sale.dart';
import 'package:soundnest_mobile/widgets/toast.dart';

class AddToDealsPage extends StatefulWidget {
  const AddToDealsPage({super.key});

  @override
  State<AddToDealsPage> createState() => _AddToDealsPageState();
}

class _AddToDealsPageState extends State<AddToDealsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  List<AvailableProduct> _availableProducts = [];
  List<AvailableProduct> _filteredProducts = [];
  String _selectedPriceRange = 'All';
  String _selectedRatingRange = 'All';
  AvailableProduct? _selectedProduct;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  // Price range options (in Rupiah)
  final List<String> _priceRanges = [
    'All',
    'Below 500k',
    '500k to 1.5M',
    '1.5M to 3M',
    'Above 3M'
  ];

  // Rating range options
  final List<String> _ratingRanges = [
    'All',
    '8 to 10',
    '6 to 8',
    'Below 6',
  ];

  @override
  void initState() {
    super.initState();
    _fetchAvailableProducts();
  }

  Future<void> _fetchAvailableProducts() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/best-deals/json/'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> productsJson = responseData['available_products'];

        setState(() {
          _availableProducts = productsJson
              .map((json) => AvailableProduct.fromJson(json))
              .toList();
          _filteredProducts = List.from(_availableProducts);
        });
      }
    } catch (e) {
      if (mounted) {
        Toast.error(context, 'Error loading products: $e');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterProducts() {
    var filtered = _availableProducts.where((product) {
      // Apply search filter
      final searchMatch = product.productName
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      // Apply price range filter
      bool priceMatch = true;
      switch (_selectedPriceRange) {
        case 'Below 500k':
          priceMatch = product.price < 500000;
          break;
        case '500k to 1.5M':
          priceMatch = product.price >= 500000 && product.price < 1500000;
          break;
        case '1.5M to 3M':
          priceMatch = product.price >= 1500000 && product.price < 3000000;
          break;
        case 'Above 3M':
          priceMatch = product.price >= 3000000;
          break;
      }

      // Apply rating range filter
      bool ratingMatch = true;
      switch (_selectedRatingRange) {
        case '8 to 10':
          ratingMatch = product.rating >= 8 && product.rating <= 10;
          break;
        case '6 to 8':
          ratingMatch = product.rating >= 6 && product.rating < 8;
          break;
        case 'Below 6':
          ratingMatch = product.rating < 6;
          break;
      }

      return searchMatch && priceMatch && ratingMatch;
    }).toList();

    setState(() => _filteredProducts = filtered);
  }

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
    if (!_formKey.currentState!.validate() || _selectedProduct == null) {
      Toast.error(context, 'Please fill all fields correctly');
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
      final response = await http.post(
        Uri.parse('http://localhost:8000/best-deals/add-to-deals/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'product_id': _selectedProduct!.id,
          'discount': int.parse(_discountController.text),
          'end_date': endDateTime.toIso8601String(),
        }),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          Toast.success(context, 'Product added to deals successfully');
          Navigator.pop(context);
        } else {
          final error = json.decode(response.body)['message'];
          throw Exception(error);
        }
      }
    } catch (e) {
      if (mounted) {
        Toast.error(context, 'Error adding product to deals: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Add to Deals', style: TextStyle(color: Colors.white)),
        leading: Transform.translate(
          offset: const Offset(12, 0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Products',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => _filterProducts(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Price Range Filter
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedPriceRange,
                      decoration: const InputDecoration(
                        labelText: 'Filter by Price',
                      ),
                      items: _priceRanges.map((String range) {
                        return DropdownMenuItem(
                          value: range,
                          child: Text(range),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedPriceRange = newValue;
                            _filterProducts();
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8), // Add space between filters

                  // Rating Range Filter
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedRatingRange,
                      decoration: const InputDecoration(
                        labelText: 'Filter by Rating',
                      ),
                      items: _ratingRanges.map((String range) {
                        return DropdownMenuItem(
                          value: range,
                          child: Text(range),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedRatingRange = newValue;
                            _filterProducts();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            final isSelected =
                                _selectedProduct?.id == product.id;
                            return Container(
                              decoration: BoxDecoration(
                                border: isSelected
                                    ? Border.all(
                                        color: const Color.fromARGB(
                                            255, 235, 192, 137),
                                        width: 2)
                                    : null,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: ListTile(
                                title: Text(product.productName),
                                subtitle: Text(
                                  'Price: ${NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(product.price)}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star,
                                        color:
                                            Colors.amber), // Optional star icon
                                    Text(product.rating
                                        .toStringAsFixed(1)), // Display rating
                                  ],
                                ),
                                selected: isSelected,
                                onTap: () {
                                  setState(() => _selectedProduct = product);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
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
                        final now = DateTime.now();
                        final selectedDate = _selectedDate;
                        final selectedTime = _selectedTime;
                        if (selectedDate != null) {
                          if (selectedDate.year == now.year &&
                              selectedDate.month == now.month &&
                              selectedDate.day == now.day) {
                            // If same day, time must be in the future
                            if (selectedTime != null) {
                              final currentTime = TimeOfDay.now();
                              final selectedDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                              final currentDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                currentTime.hour,
                                currentTime.minute,
                              );

                              if (selectedDateTime.isBefore(currentDateTime)) {
                                return 'Selected time must be in the future';
                              }
                            }
                          } else if (selectedDate.isBefore(DateTime(
                            now.year,
                            now.month,
                            now.day,
                          ))) {
                            return 'Selected date cannot be in the past';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
                child: const Text('Add to Deals',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _discountController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }
}
