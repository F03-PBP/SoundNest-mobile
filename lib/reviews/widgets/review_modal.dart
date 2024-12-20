import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:soundnest_mobile/authentication/models/user_model.dart';
import 'package:soundnest_mobile/reviews/models/reviews_model.dart';
import 'package:soundnest_mobile/reviews/services/reviews_service.dart';
import 'package:soundnest_mobile/widgets/toast.dart';

// Review Modal for Adding and Editing Reviews
class ReviewModal extends StatefulWidget {
  final String productId;
  final Review? existingReview;
  final VoidCallback onReviewAdded;

  const ReviewModal(
      {super.key,
      required this.productId,
      this.existingReview,
      required this.onReviewAdded});

  @override
  State<ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends State<ReviewModal> {
  int? selectedRating;
  final TextEditingController _reviewController = TextEditingController();
  bool isLoading = false;

  Future<void> submitReview() async {
    if (selectedRating == null || _reviewController.text.isEmpty) {
      Toast.error(context, 'Please provide a rating and review text');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final userModel = Provider.of<UserModel>(context, listen: false);

    // ReviewsService
    final response = widget.existingReview == null
        ? await ReviewsService.addReview(
            widget.productId,
            selectedRating,
            _reviewController.text,
            userModel,
          )
        : await ReviewsService.editReview(
            widget.existingReview!.id,
            selectedRating!,
            _reviewController.text,
            userModel,
          );

    if (mounted) {
      if (response['success']) {
        widget.onReviewAdded();
        Toast.success(
          context,
          widget.existingReview == null
              ? 'Review added successfully'
              : 'Review updated successfully',
        );
        Navigator.pop(context);
      } else {
        Toast.error(context, 'An error occurred. Try again later.');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      selectedRating = widget.existingReview!.rating;
      _reviewController.text = widget.existingReview!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.existingReview == null ? 'Rate Product' : 'Edit Review',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(10, (index) {
                return Padding(
                  padding: EdgeInsets.zero, // Remove the default padding
                  child: IconButton(
                    icon: Icon(
                      Icons.star,
                      color: selectedRating != null && selectedRating! > index
                          ? const Color(0xFFE7B66B)
                          : Colors.grey,
                      size: 16,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                    visualDensity:
                        VisualDensity.compact, // Tampilan lebih rapat
                  ),
                );
              }),
            ),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe your experience...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : submitReview,
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primaryContainer)
                  : const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
