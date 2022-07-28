import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context);
    Cart cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          footer: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTileBar(
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black87,
              leading: product.isFavorite
                  ? IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onPressed: () => product.toggleFavorite(),
                    )
                  : IconButton(
                      icon: const Icon(Icons.favorite_outline),
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () => product.toggleFavorite()),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart_outlined),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  cart.addItem(CartItem(product: product));
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      'Added item to cart!!!',
                    ),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeLastItem();
                        }),
                    duration: const Duration(seconds: 1, milliseconds: 500),
                  ));
                },
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(
                context, ProductDetailScreen.routeName,
                arguments: {'id': product.id}),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
