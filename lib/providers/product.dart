import 'package:flutter/material.dart';

class Product with ChangeNotifier{
  static var currentId = 1;
  final int id = currentId++;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;


  void toggleFavorite(){
    isFavorite = !isFavorite;
    notifyListeners();
  }

//<editor-fold desc="Data Methods">

  Product({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite=false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          price == other.price &&
          imageUrl == other.imageUrl &&
          isFavorite == other.isFavorite);

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      price.hashCode ^
      imageUrl.hashCode ^
      isFavorite.hashCode;

  @override
  String toString() {
    return 'Product{ title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite,}';
  }

  Product copyWith({
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Product(
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
      isFavorite: map['isFavorite'] as bool,
    );
  }

//</editor-fold>
}
