import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../providers/cart.dart';

class CartScreen extends StatefulWidget {
  static var routeName = '/cart_screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isAddingOrder = false;

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    var orders = Provider.of<Orders>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: Column(
          children: [
            Consumer<Cart>(
                builder: (context, cart, _) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            Badge(
                              shape: BadgeShape.square,
                              borderRadius: BorderRadius.circular(16),
                              animationDuration:
                                  const Duration(milliseconds: 200),
                              animationType: BadgeAnimationType.scale,
                              badgeContent: Text(
                                '\$${cart.total.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              badgeColor: Theme.of(context).colorScheme.primary,
                            ),
                            TextButton(
                                onPressed: () async {
                                  setState(() => isAddingOrder = true);
                                  await orders.addOrder(cart);
                                  cart.clear();
                                  setState(() => isAddingOrder = false);
                                },
                                child: isAddingOrder
                                    ? const SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3.0,
                                        ))
                                    : const Text(
                                        'ORDER NOW',
                                      ))
                          ],
                        ),
                      ),
                    )),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider<CartItem>.value(
                      value: cart.items[index],
                      child: const CartItemWidget(),
                    );
                  }),
            ),
          ],
        ));
  }
}
