import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:soundnest_mobile/authentication/models/user_model.dart';
import 'package:soundnest_mobile/reviews/models/reviews_model.dart';
import 'package:soundnest_mobile/reviews/services/reviews_service.dart';
import 'package:soundnest_mobile/reviews/widgets/review_modal.dart';
import 'package:soundnest_mobile/widgets/toast.dart';

class ReviewsPage extends StatefulWidget {
  final String productId;
  const ReviewsPage({super.key, required this.productId});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late UserModel userModel;
  bool _isLoading = true;
  String _selectedRating = 'All';
  List<Review> reviews = [];
  List<Review> filteredReviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    userModel = Provider.of<UserModel>(context, listen: false);

    try {
      // ReviewsService
      List<Review> fetchedReviews =
          await ReviewsService.fetchReviews(productId: widget.productId);
      setState(() {
        reviews = fetchedReviews;
        _isLoading = false;
        _filterReviews();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Toast.error(context, 'Failed to fetch reviews: $e. Try again later.');
      }
    }
  }

  void _filterReviews() {
    setState(() {
      if (_selectedRating == 'All') {
        filteredReviews = reviews;
      } else {
        filteredReviews = reviews
            .where((review) => review.rating.toString() == _selectedRating)
            .toList();
      }
    });
  }

  Future<void> _deleteReview(String reviewId) async {
    final result = await ReviewsService.deleteReview(reviewId, userModel);
    if (mounted) {
      if (result['success']) {
        Toast.success(context, 'Successfully deleted review');
        _fetchReviews();
      } else {
        Toast.error(context,
            "Failed to delete review: ${result['message']}. Try again later.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ReviewModal(
                          productId: widget.productId,
                          existingReview: null,
                          onReviewAdded: _fetchReviews,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.all(16.0),
                    ),
                    child: const Text(
                      'Write a Review',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Filter Dropdown
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownButton<String>(
                      value: _selectedRating,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black),
                      dropdownColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRating = newValue!;
                          _filterReviews();
                        });
                      },
                      items: <String>[
                        'All',
                        '1',
                        '2',
                        '3',
                        '4',
                        '5',
                        '6',
                        '7',
                        '8',
                        '9',
                        '10'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value == 'All' ? 'All Ratings' : '$value ★',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Review List
                  ListView.builder(
                    itemCount: filteredReviews.length,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Satu layar ke scroll
                    itemBuilder: (BuildContext context, int index) {
                      final review = filteredReviews[index];
                      final isOwner = review.userName == userModel.username;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Text(
                                  review.userInitials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                review.userName,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),

                              // Owner bisa hapus dan edit reviewnya sendiri
                              if (isOwner || userModel.isSuperuser) ...[
                                if (isOwner)
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ReviewModal(
                                          productId: widget.productId,
                                          existingReview: review,
                                          onReviewAdded: _fetchReviews,
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20.0,
                                    ),
                                  ),
                                IconButton(
                                  onPressed: () => _deleteReview(review.id),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20.0,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: List.generate(
                              10,
                              (index) => Icon(
                                index < review.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color(0xFFE7B66B),
                                size: 16.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            review.description,
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Time: ${review.updatedAt}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                        ],
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
