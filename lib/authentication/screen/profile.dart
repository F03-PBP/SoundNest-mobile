import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:soundnest_mobile/authentication/models/user_model.dart';
import 'package:soundnest_mobile/authentication/services/auth_service.dart';
import 'package:soundnest_mobile/authentication/widgets/title.dart';
import 'package:soundnest_mobile/reviews/models/reviews_model.dart';
import 'package:soundnest_mobile/reviews/services/reviews_service.dart';
import 'package:soundnest_mobile/reviews/widgets/review_card.dart';
import 'package:soundnest_mobile/widgets/toast.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Review> _reviews = [];
  bool _isLoading = true;
  bool _showAll = false;
  String userTitle = 'Starter';

  @override
  void initState() {
    super.initState();
    _fetchUserReviews(); // Fetch user reviews
  }

  String getTitle() {
    // Title user
    if (_reviews.length < 10) {
      return 'Starter';
    } else if (_reviews.length >= 10 && _reviews.length < 20) {
      return 'Explorer';
    } else if (_reviews.length >= 20 && _reviews.length < 30) {
      return 'Pro';
    } else {
      return 'Legendary';
    }
  }

  Future<void> _fetchUserReviews() async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    try {
      // ReviewsService
      final reviews = await ReviewsService.fetchReviews(
        byUser: true,
        userModel: userModel,
      );
      setState(() {
        _reviews = reviews;
        _isLoading = false;
        userTitle = getTitle();
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final userModel = Provider.of<UserModel>(context);
    final username = userModel.username;
    final initials = userModel.initials;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // No back button
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC5A684),
              Color(0x00C5A684),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 50,
                        child: Text(
                          initials,
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          TitleBox(title: userTitle),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Perlu 2x Expanded agar ListView bisa scroll (tidak overflow)
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                // Show 2 reviews
                                itemCount: _showAll
                                    ? _reviews.length
                                    : (_reviews.length > 2
                                        ? 2
                                        : _reviews.length),
                                itemBuilder: (context, index) {
                                  final review = _reviews[index];
                                  return ReviewCard(
                                    description: review.description,
                                    rating: review.rating,
                                    productName: review.productName,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_reviews.length > 2)
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        Theme.of(context).colorScheme.secondary,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showAll = !_showAll;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8), // Padding
                                    ),
                                    child: Text(
                                      // Show all reviews
                                      _showAll
                                          ? 'View Less'
                                          : 'View More Reviews',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // Text color
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final response =
                              await AuthService.logoutUser(request, userModel);
                          if (context.mounted) {
                            if (response) {
                              userModel.logout();
                              Navigator.pushReplacementNamed(context, '/login');
                              Toast.success(
                                  context, 'Successfully logged out.');
                            } else {
                              Toast.error(context, 'Failed to log out.');
                            }
                          }
                        },
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
