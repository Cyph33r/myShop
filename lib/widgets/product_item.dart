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
                      icon: const Icon(Icons.favorite),
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () => product.toggleFavorite(),
                    )
                  : IconButton(
                      icon: const Icon(Icons.favorite_outline),
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () => product.toggleFavorite()),
              trailing: IconButton(
                icon: const Icon(Icons.shopping_cart),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () => cart.addItem(CartItem(product: product)),
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
