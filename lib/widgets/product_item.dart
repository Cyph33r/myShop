import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context);
    Products productsProvider = Provider.of<Products>(context, listen: false);
    Cart cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      key: ValueKey(product.id),
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
                      onPressed: () => productsProvider.toggleFavorite(product),
                    )
                  : IconButton(
                      icon: const Icon(Icons.favorite_outline),
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () => productsProvider.toggleFavorite(product),
                    ),
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
            child: Hero(
              tag: ValueKey(product.id),
              child: Image.network(
                product.imageUrl,
                errorBuilder: (context, _, __) => const Center(
                  child: Icon(Icons.emoji_emotions_outlined),
                ),
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const Center(child: CircularProgressIndicator()),
                fit: BoxFit.cover,
              ),
            ),
          )),
    );
  }
}
