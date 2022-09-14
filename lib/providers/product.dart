import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class Product with ChangeNotifier {
  late final String id;
  late final String title;
  late final String description;
  late final double price;
  late final String imageUrl;
  bool isFavorite = false;


  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Product.fromDocumentSnapshot(
      QueryDocumentSnapshot queryDocumentSnapshot, bool isFavorite)
      : this(
            id: queryDocumentSnapshot.get('id') as String,
            title: queryDocumentSnapshot.get('title') as String,
            description: queryDocumentSnapshot.get('description') as String,
            price: queryDocumentSnapshot.get('price') as double,
            imageUrl: queryDocumentSnapshot.get('imageUrl') as String,
            isFavorite: isFavorite);

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
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode ^
      imageUrl.hashCode ^
      isFavorite.hashCode;

  @override
  String toString() {
    return 'Product{id:$id,title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite,}';
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
      isFavorite: map['isFavorite'] as bool,
    );
  }
}
