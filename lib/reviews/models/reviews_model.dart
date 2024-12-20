import 'package:json_annotation/json_annotation.dart';

part 'reviews_model.g.dart';

@JsonSerializable()
class Review {
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'user_id', defaultValue: 0)
  final int userId;

  @JsonKey(name: 'user_name', defaultValue: 'Unknown')
  final String userName;

  @JsonKey(name: 'user_initials', defaultValue: 'XX')
  final String userInitials;

  @JsonKey(name: 'product_id', defaultValue: '')
  final String productId;

  @JsonKey(name: 'product_name', defaultValue: 'Unknown Product')
  final String productName;

  @JsonKey(name: 'product_price', defaultValue: 0)
  final int productPrice;

  @JsonKey(name: 'rating', defaultValue: 0)
  final int rating;

  @JsonKey(name: 'stars', defaultValue: [])
  final List<int> stars;

  @JsonKey(name: 'empty_stars', defaultValue: [])
  final List<int> emptyStars;

  @JsonKey(name: 'description', defaultValue: '')
  final String description;

  @JsonKey(name: 'updated_at', defaultValue: '')
  final String updatedAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userInitials,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.rating,
    required this.stars,
    required this.emptyStars,
    required this.description,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
