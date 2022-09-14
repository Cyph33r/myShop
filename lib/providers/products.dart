import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/database_collection.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final startingItems = [
    Product(
      id: '',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: '',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: '',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: '',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  final _allItems = <String, Product>{};
  final _myItems = <String,Product>{};
  final _userFavorites = <String>{};
  bool _showFavoritesOnly = false;

  Products() {}

  List<Product> get items {
    return _showFavoritesOnly
        ? _allItems.values
            .where((Product product) => _userFavorites.contains(product.id))
            .toList()
        : _allItems.values
            .toList();
  }

  Future<void> toggleFavorite(Product product) async {
    product.isFavorite = !product.isFavorite;
    product.notifyListeners();
    await Databases.favoritesCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> favoritesList) {
      if (favoritesList.exists) {
        if (favoritesList.data() != null) {
          _userFavorites.addAll((favoritesList.get('user_favorites') as List)
              .map((e) => e.toString()));
        }
      }
    });
    print(_userFavorites);
    if (product.isFavorite)
      _userFavorites.add(product.id);
    else
      _userFavorites.remove(product.id);
    await Databases.favoritesCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({'user_favorites': _userFavorites.toList()}).onError(
            (error, stackTrace) {
      product.isFavorite = !product.isFavorite;
      product.notifyListeners();
    });
  }

  Future<void> getProductsFromDatabase(bool rebuild) async {
    _allItems.clear();
    _myItems.clear();
    _userFavorites.clear();
    final documents = await Databases.productsCollection.get();

    // get the user favorite products
    await Databases.favoritesCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> favoritesList) {
      if (favoritesList.exists) {
        if (favoritesList.data() != null) {
          _userFavorites.addAll((favoritesList.get('user_favorites') as List)
              .map((e) => e.toString()));
        }
      }
    });
    //get all products
    for (var document in documents.docs) {
      print(_userFavorites.toString() + document.id.toString());
      _allItems[document.id] = Product.fromDocumentSnapshot(
          document, _userFavorites.contains(document.id));
      if(document.get('creator_id') == FirebaseAuth.instance.currentUser!.uid)
        _myItems[document.id] = Product.fromDocumentSnapshot(
            document, _userFavorites.contains(document.id));
    }

    if (rebuild) {
      notifyListeners();
    }
  }

  void showAllProducts() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    try {
      var productsExists = (await Databases.productsCollection
                  .where('id', isEqualTo: product.id)
                  .limit(1)
                  .get())
              .size >=
          1;
      if (productsExists) {
        _allItems[product.id] = product;
        await Databases.productsCollection
            .doc(product.id)
            .update(product.toMap());
      } else {
        final documentReference =
            await Databases.productsCollection.add(product.toMap());
        _allItems[documentReference.id] =
            product.copyWith(id: documentReference.id);
        await Databases.productsCollection
            .doc(documentReference.id)
            .update({'id': documentReference.id});
      }
    } catch (error) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // final url = Uri.https(
  //     "flutter-shop-app-fed8d-default-rtdb.firebaseio.com", "/products.json");
  // http.post(url, body: product.toJson()).then((response) {});

  void removeProductById(String id) async {
    await Databases.productsCollection.doc(id.toString()).delete();
    _allItems.remove(id);
    notifyListeners();
  }

  void showOnlyFavoriteProducts() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  Product findById(String id) {
    return _allItems[id]!;
  }
}
