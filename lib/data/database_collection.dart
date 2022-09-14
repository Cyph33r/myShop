import 'package:cloud_firestore/cloud_firestore.dart';

class Databases {
  static final productsCollection =
      FirebaseFirestore.instance.collection('products');
  static final ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  static final favoritesCollection =
      FirebaseFirestore.instance.collection('favorites');
}
