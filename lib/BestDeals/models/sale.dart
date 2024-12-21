import 'dart:convert';

// To parse this JSON data, do
//
//     final sale = saleFromJson(jsonString);

Sale saleFromJson(String str) => Sale.fromJson(json.decode(str));

String saleToJson(Sale data) => json.encode(data.toJson());

class Sale {
  List<SaleItem> sales;
  List<TopPick> topPicks;
  List<TopPickGuest> topPicksGuest;
  List<LeastCountdown> leastCountdown;
  List<AvailableProduct> availableProducts;

  Sale({
    required this.sales,
    required this.topPicks,
    required this.topPicksGuest,
    required this.leastCountdown,
    required this.availableProducts,
  });

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
    sales: List<SaleItem>.from(json["sales"].map((x) => SaleItem.fromJson(x))),
    topPicks: List<TopPick>.from(json["top_picks"].map((x) => TopPick.fromJson(x))),
    topPicksGuest: List<TopPickGuest>.from(json["top_picks_guest"].map((x) => TopPickGuest.fromJson(x))),
    leastCountdown: List<LeastCountdown>.from(json["least_countdown"].map((x) => LeastCountdown.fromJson(x))),
    availableProducts: List<AvailableProduct>.from(json["available_products"].map((x) => AvailableProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sales": List<dynamic>.from(sales.map((x) => x.toJson())),
    "top_picks": List<dynamic>.from(topPicks.map((x) => x.toJson())),
    "top_picks_guest": List<dynamic>.from(topPicksGuest.map((x) => x.toJson())),
    "least_countdown": List<dynamic>.from(leastCountdown.map((x) => x.toJson())),
    "available_products": List<dynamic>.from(availableProducts.map((x) => x.toJson())),
  };
}

class SaleItem {
  String id;
  String productName;
  int originalPrice;
  int discount;
  int price;
  double rating;
  DateTime saleEndTime;
  String timeRemaining;
  int reviews;

  SaleItem({
    required this.id,
    required this.productName,
    required this.originalPrice,
    required this.discount,
    required this.price,
    required this.rating,
    required this.saleEndTime,
    required this.timeRemaining,
    required this.reviews,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) => SaleItem(
    id: json["id"],
    productName: json["product_name"],
    originalPrice: json["original_price"],
    discount: json["discount"],
    price: json["price"],
    rating: json["rating"]?.toDouble(),
    saleEndTime: DateTime.parse(json["sale_end_time"]),
    timeRemaining: json["time_remaining"],
    reviews: json["reviews"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "original_price": originalPrice,
    "discount": discount,
    "price": price,
    "rating": rating,
    "sale_end_time": saleEndTime.toIso8601String(),
    "time_remaining": timeRemaining,
    "reviews": reviews,
  };
}

class TopPick {
  String id;
  String productName;
  int originalPrice;
  int discount;
  int price;
  double rating;
  DateTime saleEndTime;
  String timeRemaining;
  int reviews;

  TopPick({
    required this.id,
    required this.productName,
    required this.originalPrice,
    required this.discount,
    required this.price,
    required this.rating,
    required this.saleEndTime,
    required this.timeRemaining,
    required this.reviews,
  });

  factory TopPick.fromJson(Map<String, dynamic> json) => TopPick(
    id: json["id"],
    productName: json["product_name"],
    originalPrice: json["original_price"],
    discount: json["discount"],
    price: json["price"],
    rating: json["rating"]?.toDouble(),
    saleEndTime: DateTime.parse(json["sale_end_time"]),
    timeRemaining: json["time_remaining"],
    reviews: json["reviews"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "original_price": originalPrice,
    "discount": discount,
    "price": price,
    "rating": rating,
    "sale_end_time": saleEndTime.toIso8601String(),
    "time_remaining": timeRemaining,
    "reviews": reviews,
  };
}

class TopPickGuest {
  String id;
  String productName;
  int originalPrice;
  int discount;
  int price;
  double rating;
  DateTime saleEndTime;
  String timeRemaining;
  int reviews;

  TopPickGuest({
    required this.id,
    required this.productName,
    required this.originalPrice,
    required this.discount,
    required this.price,
    required this.rating,
    required this.saleEndTime,
    required this.timeRemaining,
    required this.reviews,
  });

  factory TopPickGuest.fromJson(Map<String, dynamic> json) => TopPickGuest(
    id: json["id"],
    productName: json["product_name"],
    originalPrice: json["original_price"],
    discount: json["discount"],
    price: json["price"],
    rating: json["rating"]?.toDouble(),
    saleEndTime: DateTime.parse(json["sale_end_time"]),
    timeRemaining: json["time_remaining"],
    reviews: json["reviews"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "original_price": originalPrice,
    "discount": discount,
    "price": price,
    "rating": rating,
    "sale_end_time": saleEndTime.toIso8601String(),
    "time_remaining": timeRemaining,
    "reviews": reviews,
  };
}

class LeastCountdown {
  String id;
  String productName;
  int originalPrice;
  int discount;
  int price;
  double rating;
  DateTime saleEndTime;
  String timeRemaining;
  int reviews;

  LeastCountdown({
    required this.id,
    required this.productName,
    required this.originalPrice,
    required this.discount,
    required this.price,
    required this.rating,
    required this.saleEndTime,
    required this.timeRemaining,
    required this.reviews,
  });

  factory LeastCountdown.fromJson(Map<String, dynamic> json) => LeastCountdown(
    id: json["id"],
    productName: json["product_name"],
    originalPrice: json["original_price"],
    discount: json["discount"],
    price: json["price"],
    rating: json["rating"]?.toDouble(),
    saleEndTime: DateTime.parse(json["sale_end_time"]),
    timeRemaining: json["time_remaining"],
    reviews: json["reviews"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "original_price": originalPrice,
    "discount": discount,
    "price": price,
    "rating": rating,
    "sale_end_time": saleEndTime.toIso8601String(),
    "time_remaining": timeRemaining,
    "reviews": reviews,
  };
}

class AvailableProduct {
  String id;
  String productName;
  int price;
  double rating;
  int reviews;

  AvailableProduct({
    required this.id,
    required this.productName,
    required this.price,
    required this.rating,
    required this.reviews,
  });

  factory AvailableProduct.fromJson(Map<String, dynamic> json) => AvailableProduct(
    id: json["id"],
    productName: json["product_name"],
    price: json["price"],
    rating: json["rating"]?.toDouble(),
    reviews: json["reviews"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "price": price,
    "rating": rating,
    "reviews": reviews,
  };
}
