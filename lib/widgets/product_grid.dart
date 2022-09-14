import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import 'package:shop_app/widgets/product_item.dart';

import '../providers/product.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    var products = <Product>[];
    return FutureBuilder<void>(future: Future.sync(() async {
      await productsData.getProductsFromDatabase(false);
      products = await productsData.items;
    }), builder: (_, state) {
      return state.connectionState == ConnectionState.waiting
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (_, index) {
                return ChangeNotifierProvider.value(
                    value: products[index], child: const ProductItem());
              });
    });
  }
}
