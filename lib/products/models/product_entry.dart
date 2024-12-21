// To parse this JSON data, do
//
//     final productEntry = productEntryFromJson(jsonString);

import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(
    json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
  Model model;
  String pk;
  Fields fields;

  ProductEntry({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String productName;
  int price;
  double rating;
  int reviews;
  DateTime createdAt;

  Fields({
    required this.productName,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.createdAt,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        productName: json["product_name"],
        price: json["price"],
        rating: json["rating"]?.toDouble(),
        reviews: json["reviews"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "price": price,
        "rating": rating,
        "reviews": reviews,
        "created_at": createdAt.toIso8601String(),
      };
}

enum Model { PRODUCTS_PRODUCT }

final modelValues = EnumValues({"products.product": Model.PRODUCTS_PRODUCT});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
