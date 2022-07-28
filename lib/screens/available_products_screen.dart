import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/available_product_item.dart';

class AvailableProductsScreen extends StatelessWidget {
  static const routeName = '/available_products_screen';

  const AvailableProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    var items = productsProvider.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
          itemCount: productsProvider.items.length,
          itemBuilder: (_, index) => Column(
                children: [
                  AvailableProductItem(
                    id:items[index].id,
                      title: items[index].title,
                      imageUrl: items[index].imageUrl),
                  Divider(),
                ],
              )),
    );
  }
}
