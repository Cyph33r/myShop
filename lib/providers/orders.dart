import 'package:flutter/material.dart';

import '../data/database_collection.dart';
import 'cart.dart';

class Order {
  final String id;
  final List<CartItem> products;
  final DateTime time;
  final double subTotal;
  bool isDelivered;

  Order({
    required this.id,
    required this.products,
    required this.time,
    required this.subTotal,
    this.isDelivered = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          products == other.products &&
          time == other.time &&
          subTotal == other.subTotal &&
          isDelivered == other.isDelivered);

  @override
  int get hashCode =>
      id.hashCode ^
      products.hashCode ^
      time.hashCode ^
      subTotal.hashCode ^
      isDelivered.hashCode;

  @override
  String toString() {
    return 'Order{ id: $id, products: $products, time: $time, subTotal: $subTotal, isDelivered: $isDelivered,}';
  }

  Order copyWith({
    String? id,
    List<CartItem>? products,
    DateTime? time,
    double? subTotal,
    bool? isDelivered,
  }) {
    return Order(
      id: id ?? this.id,
      products: products ?? this.products,
      time: time ?? this.time,
      subTotal: subTotal ?? this.subTotal,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products.map((cartItem) => cartItem.product.id).toList(),
      'time': time,
      'subTotal': subTotal,
      'isDelivered': isDelivered,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      products: map['products'] as List<CartItem>,
      time: map['time'] as DateTime,
      subTotal: map['subTotal'] as double,
      isDelivered: map['isDelivered'] as bool,
    );
  }
}

class Orders with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return _orders.toList();
  }

  Future<void> addOrder(Cart cart) async {
    final time = DateTime.now();
    final order =
        Order(id: '', products: cart.items, time: time, subTotal: cart.total);
    final documentReference = await Databases.ordersCollection.add(order.toMap());
    _orders.add(order.copyWith(id: documentReference.id));
    await documentReference.update({'id': documentReference.id}).onError((error, stackTrace) => print(error));
    notifyListeners();
  }
}
