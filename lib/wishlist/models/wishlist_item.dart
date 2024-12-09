// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String model;
    int pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String produk;
    int jumlah;
    DateTime dateAdded;
    int price;
    String namaProduk;

    Fields({
        required this.user,
        required this.produk,
        required this.jumlah,
        required this.dateAdded,
        required this.price,
        required this.namaProduk,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        produk: json["produk"],
        jumlah: json["jumlah"],
        dateAdded: DateTime.parse(json["date_added"]),
        price: json["price"],
        namaProduk: json["nama_produk"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "produk": produk,
        "jumlah": jumlah,
        "date_added": dateAdded.toIso8601String(),
        "price": price,
        "nama_produk": namaProduk,
    };
}
