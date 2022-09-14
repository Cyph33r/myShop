import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../providers/products.dart';

class AvailableProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const AvailableProductItem(
      {required this.id, required this.title, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<Products>(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName,arguments: id),
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                )),
            IconButton(
                onPressed: () => showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Delete product'),
                            content: const Text(
                                'Are sure you want to delete this product'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text(
                                    'No',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              TextButton(
                                  onPressed: () {

                                    Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    'Yes',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ))
                            ],
                          )).then((remove) {
                    if (remove!) productProvider.removeProductById(id);
                  }),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ))
          ],
        ),
      ),
    );
  }
}
