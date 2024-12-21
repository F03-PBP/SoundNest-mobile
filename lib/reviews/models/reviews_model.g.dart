// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      id: json['id'] as String? ?? '',
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      userName: json['user_name'] as String? ?? 'Unknown',
      userInitials: json['user_initials'] as String? ?? 'XX',
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? 'Unknown Product',
      productPrice: (json['product_price'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      stars: (json['stars'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      emptyStars: (json['empty_stars'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      description: json['description'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'user_initials': instance.userInitials,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_price': instance.productPrice,
      'rating': instance.rating,
      'stars': instance.stars,
      'empty_stars': instance.emptyStars,
      'description': instance.description,
      'updated_at': instance.updatedAt,
    };
