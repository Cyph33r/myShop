import 'package:flutter/material.dart';

import 'cart.dart';

class Order {
  final int id;
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
    return 'Order{ id: $id, orders: $products, time: $time, subTotal: $subTotal, isDelivered: $isDelivered,}';
  }

  Order copyWith({
    int? id,
    List<CartItem>? orders,
    DateTime? time,
    double? subTotal,
    bool? isDelivered,
  }) {
    return Order(
      id: id ?? this.id,
      products: orders ?? this.products,
      time: time ?? this.time,
      subTotal: subTotal ?? this.subTotal,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orders': products,
      'time': time,
      'subTotal': subTotal,
      'isDelivered': isDelivered,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      products: map['orders'] as List<CartItem>,
      time: map['time'] as DateTime,
      subTotal: map['subTotal'] as double,
      isDelivered: map['isDelivered'] as bool,
    );
  }

//</editor-fold>
}

class Orders with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return _orders.toList();
  }

  void addOrder(Cart cart) {
    var time = DateTime.now();
    _orders.add(Order(
        id: time.millisecondsSinceEpoch,
        products: cart.items,
        time: time,
        subTotal: cart.total));
  }
}
