import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static var routeName = '/cart_screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider<CartItem>.value(
                      value: cart.items[index],
                      child: const CartItemWidget(),
                    );
                  }),
            ),
            Consumer<Cart>(
                builder: (context, cart, _) =>
                    Text(cart.total.toStringAsFixed(2)))
          ],
        ));
  }
}
