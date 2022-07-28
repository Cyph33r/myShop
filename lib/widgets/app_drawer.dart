import 'package:flutter/material.dart';
import 'package:shop_app/screens/available_products_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Happy Shopping'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          ListTile(
            leading: const Icon(
              Icons.delivery_dining,
              color: Colors.black,
            ),
            title: const Text('Orders'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ), ListTile(
            leading: const Icon(
              Icons.edit,
              color: Colors.black,
            ),
            title: const Text('Manage Products'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AvailableProductsScreen.routeName),
          )
        ],
      ),
    );
  }
}
