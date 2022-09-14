import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/cart.dart';
import '../services/notification_services.dart';
import '../widgets/product_grid.dart';

enum FilterOverFlowMenuItems { favorites, all }

class ProductsOverviewScreen extends StatelessWidget {
  static var routeName = '/product_overview_screen';

  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context,listen: false);
    final authProvider = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.access_alarms),
          onPressed: () async =>
              NotificationService().show("Tade", "I am groot")),
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          Consumer<Cart>(
              builder: (ctx, cart, child) => GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(CartScreen.routeName),
                    behavior: HitTestBehavior.opaque,
                    child: Badge(
                      position: const BadgePosition(top: 0, end: -6),
                      badgeContent: Text(cart.items.length.toString()),
                      badgeColor: Theme.of(context).colorScheme.secondary,
                      animationType: BadgeAnimationType.scale,
                      animationDuration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.shopping_cart,
                        size: 30,
                      ),
                    ),
                  )),
          IconButton(
              onPressed: () {
                authProvider.signOut();
              },
              icon: const Icon(Icons.account_circle_rounded)),
          Consumer<Products>(
            builder: (context,productsProvider,_) {
              return PopupMenuButton(
                  onSelected: (selectedValue) {
                    if (selectedValue == FilterOverFlowMenuItems.all) {
                      productsProvider.showAllProducts();
                    } else if (selectedValue == FilterOverFlowMenuItems.favorites) {
                      productsProvider.showOnlyFavoriteProducts();
                    } else {
                      Navigator.of(context).pushNamed(OrdersScreen.routeName);
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: FilterOverFlowMenuItems.favorites,
                          child: Text('Only Favorites'),
                        ),
                        const PopupMenuItem(
                          value: FilterOverFlowMenuItems.all,
                          child: Text('Show All'),
                        ),
                      ]);
            }
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
          onRefresh: () => productsProvider.getProductsFromDatabase(false),
          child: ProductGrid()),
    );
  }
}
