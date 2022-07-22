import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class CartItem with ChangeNotifier {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItem &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          quantity == other.quantity);

  CartItem operator +(CartItem other) {
    if (runtimeType == other.runtimeType) {
      return copyWith(quantity: quantity + other.quantity);
    } else {
      return other;
    }
  }

  void increaseQuantity() {
    quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    quantity--;
    notifyListeners();
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;

  @override
  String toString() {
    return 'CartItem{product: $product, quantity: $quantity,}';
  }

  CartItem copyWith({
    int? id,
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: map['product'] as Product,
      quantity: map['quantity'] as int,
    );
  }
}

class Cart with ChangeNotifier {
  double get total {
    double currentTotal = 0;
    for (var item in _items) {
      currentTotal += item.quantity * item.product.price;
    }
    return currentTotal;
  }

  final List<CartItem> _items = [];

  List<CartItem> get items {
    return [..._items];
  }

  void refresh() => notifyListeners();

  void addItem(CartItem item) {
    var index = _items
        .indexWhere((itemCheck) => itemCheck.product.id == item.product.id);
    if (index != -1) {
      _items[index] = item + _items[index];
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  @override
  String toString() {
    var toReturn = '';
    for (var item in items) {
      toReturn += '${item.toString()} \n';
    }
    return toReturn;
  }
}
