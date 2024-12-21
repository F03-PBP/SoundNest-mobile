import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:soundnest_mobile/BestDeals/models/sale.dart';
import 'package:soundnest_mobile/BestDeals/widgets/product_card.dart';
import 'package:soundnest_mobile/BestDeals/screens/add_to_deals_page.dart';
import 'package:soundnest_mobile/authentication/models/user_model.dart';

class DealsCarouselItem extends StatelessWidget {
  final dynamic product;

  const DealsCarouselItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
      child: Row(
        children: [
          // Left side - Product Image
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
              child: Image.network(
                'http://127.0.0.1:8000/static/images/templateimage.webp',
                fit: BoxFit.contain,
                height: double.infinity,
              ),
            ),
          ),
          // Right side - Product Details
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      'Up to ${product.discount}% Off',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    formatRupiah(product.price),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Time remaining: ${product.timeRemaining}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
}

class DealsCarousel extends StatefulWidget {
  final List<dynamic> products;

  const DealsCarousel({
    super.key,
    required this.products,
  });

  @override
  State<DealsCarousel> createState() => _DealsCarouselState();
}

class _DealsCarouselState extends State<DealsCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < widget.products.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.products.length, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.blue : Colors.grey.shade300,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.0,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DealsCarouselItem(product: widget.products[index]),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8.0),
        _buildPageIndicator(),
      ],
    );
  }
}

class FilterModal extends StatefulWidget {
  final String selectedPriceRange;
  final String selectedRatingRange;
  final String selectedDiscountRange;
  final Function(String) onPriceRangeChanged;
  final Function(String) onRatingRangeChanged;
  final Function(String) onDiscountRangeChanged;
  final VoidCallback onApplyFilter;

  const FilterModal({
    super.key,
    required this.selectedPriceRange,
    required this.selectedRatingRange,
    required this.selectedDiscountRange,
    required this.onPriceRangeChanged,
    required this.onRatingRangeChanged,
    required this.onDiscountRangeChanged,
    required this.onApplyFilter,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late String _localPriceRange;
  late String _localRatingRange;
  late String _localDiscountRange;

  @override
  void initState() {
    super.initState();
    _localPriceRange = widget.selectedPriceRange;
    _localRatingRange = widget.selectedRatingRange;
    _localDiscountRange = widget.selectedDiscountRange;
  }

  void _handleOptionTap(
      String option, String currentValue, Function(String) onChanged) {
    // If the tapped option is already selected, set it to 'All' (unselect)
    // Otherwise, select the tapped option
    onChanged(option == currentValue ? 'All' : option);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _localPriceRange = 'All';
                    _localRatingRange = 'All';
                    _localDiscountRange = 'All';
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildFilterSection(
            'Rating',
            _localRatingRange,
            ['8 to 10', '6 to 8', 'Below 6'],
            (value) {
              setState(() {
                _handleOptionTap(value, _localRatingRange, (newValue) {
                  _localRatingRange = newValue;
                });
              });
            },
          ),
          const SizedBox(height: 16.0),
          _buildFilterSection(
            'Price',
            _localPriceRange,
            ['Below 500k', '500k to 1.5M', '1.5M to 3M', 'Above 3M'],
            (value) {
              setState(() {
                _handleOptionTap(value, _localPriceRange, (newValue) {
                  _localPriceRange = newValue;
                });
              });
            },
          ),
          const SizedBox(height: 16.0),
          _buildFilterSection(
            'Discount',
            _localDiscountRange,
            ['Below 10%', '10% to 30%', 'Above 30%'],
            (value) {
              setState(() {
                _handleOptionTap(value, _localDiscountRange, (newValue) {
                  _localDiscountRange = newValue;
                });
              });
            },
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              widget.onPriceRangeChanged(_localPriceRange);
              widget.onRatingRangeChanged(_localRatingRange);
              widget.onDiscountRangeChanged(_localDiscountRange);
              // Close the modal
              Navigator.of(context).pop();

              widget.onApplyFilter();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Apply Filter',
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

  Widget _buildFilterSection(
    String title,
    String selectedValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return InkWell(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class BestDealsPage extends StatefulWidget {
  const BestDealsPage({super.key});

  @override
  State<BestDealsPage> createState() => _BestDealsPageState();
}

class _BestDealsPageState extends State<BestDealsPage> {
  late Future<Sale> saleData;
  List<dynamic> carouselProducts = [];
  List<dynamic> filteredTopPicks = [];
  List<dynamic> filteredLeastCountdown = [];
  String _searchQuery = '';
  String _selectedPriceRange = 'All';
  String _selectedRatingRange = 'All';
  String _selectedDiscountRange = 'All';
  Sale? _currentSaleData;

  @override
  void initState() {
    super.initState();
    saleData = fetchSaleData();
  }

  Future<Sale> fetchSaleData() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/best-deals/json/'));

    if (response.statusCode == 200) {
      final sale = Sale.fromJson(jsonDecode(response.body));
      // Sort and get top 5 products with least time remaining
      setState(() {
        carouselProducts = sale.leastCountdown.take(5).toList();
        _currentSaleData = sale;
      });
      return sale;
    } else {
      throw Exception('Failed to load sale data');
    }
  }

  void refreshDealsList() {
    setState(() {
      saleData = fetchSaleData();
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModal(
        selectedPriceRange: _selectedPriceRange,
        selectedRatingRange: _selectedRatingRange,
        selectedDiscountRange: _selectedDiscountRange,
        onPriceRangeChanged: (value) =>
            setState(() => _selectedPriceRange = value),
        onRatingRangeChanged: (value) =>
            setState(() => _selectedRatingRange = value),
        onDiscountRangeChanged: (value) =>
            setState(() => _selectedDiscountRange = value),
        onApplyFilter: () {
          if (mounted && _currentSaleData != null) {
            // Check if we have the data
            setState(() {
              _filterProducts(_currentSaleData!); // Use the stored sale data
            });
          }
        },
      ),
    );
  }

  void _filterProducts(Sale saleData) {
    final topPicks = saleData.topPicks;
    final leastCountdown = saleData.leastCountdown;

    setState(() {
      filteredTopPicks = topPicks.where((product) {
        return _matchesFilter(product);
      }).toList();

      filteredLeastCountdown = leastCountdown.where((product) {
        return _matchesFilter(product);
      }).toList();
    });
  }

  bool _matchesFilter(product) {
    bool matchesSearchQuery =
        product.productName.toLowerCase().contains(_searchQuery.toLowerCase());

    // Price filter
    bool matchesPrice = _priceMatches(product);

    // Rating filter
    bool matchesRating = _ratingMatches(product);

    // Discount filter
    bool matchesDiscount = _discountMatches(product);

    return matchesSearchQuery &&
        matchesPrice &&
        matchesRating &&
        matchesDiscount;
  }

  bool _priceMatches(product) {
    switch (_selectedPriceRange) {
      case 'Below 500k':
        return product.price < 500000;
      case '500k to 1.5M':
        return product.price >= 500000 && product.price <= 1500000;
      case '1.5M to 3M':
        return product.price >= 1500000 && product.price <= 3000000;
      case 'Above 3M':
        return product.price > 3000000;
      default:
        return true;
    }
  }

  bool _ratingMatches(product) {
    switch (_selectedRatingRange) {
      case '8 to 10':
        return product.rating >= 8;
      case '6 to 8':
        return product.rating >= 6 && product.rating < 8;
      case 'Below 6':
        return product.rating < 6;
      default:
        return true;
    }
  }

  bool _discountMatches(product) {
    switch (_selectedDiscountRange) {
      case 'Below 10%':
        return product.discount < 10;
      case '10% to 30%':
        return product.discount >= 10 && product.discount <= 30;
      case 'Above 30%':
        return product.discount > 30;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

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

          // Using post-frame callback to run the filtering logic after the build phase is complete
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _filterProducts(snapshot.data!);
            }
          });

          return ListView(
            // padding: const EdgeInsets.all(16.0),
            children: [
              // Search and Filter Bar
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              // Trigger the filter after the search query changes
                              if (snapshot.hasData) {
                                _filterProducts(snapshot.data!);
                              }
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search for products',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: _showFilterModal,
                    ),
                  ],
                ),
              ),

              // Carousel
              if (carouselProducts.isNotEmpty)
                DealsCarousel(products: carouselProducts),

              const SizedBox(height: 16.0),
              if (userModel.isSuperuser)
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),

              const SectionHeader(title: 'Top Picks (sorted by rating)'),
              bestDealsGrid(filteredTopPicks),

              const SectionHeader(
                  title: 'Least Countdown (sorted by time remaining)'),
              bestDealsGrid(filteredLeastCountdown),
            ],
          );
        },
      ),
    );
  }

  Widget bestDealsGrid(List<dynamic> productData) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75, // Adjust this value to control card height
      ),
      itemCount: productData.length,
      itemBuilder: (context, index) {
        var item = productData[index];
        return LayoutBuilder(
          builder: (context, constraints) {
            return ProductCard(
              imageUrl:
                  'http://127.0.0.1:8000/static/images/templateimage.webp',
              title: item.productName,
              originalPrice: item.originalPrice,
              discountedPrice: item.price,
              rating: item.rating,
              numRatings: item.reviews,
              discount: item.discount,
              timeRemaining: item.timeRemaining,
              maxWidth: constraints.maxWidth,
              id: item.id,
              saleEndTime: item.saleEndTime,
              onDelete: () => refreshDealsList(),
            );
          },
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
