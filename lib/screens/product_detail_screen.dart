import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail_screen';

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, Object>;
    var id = arguments['id'] as String;
    var productData = Provider.of<Products>(context);
    var product = productData.findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Container(
        height: 450,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          ImageFiltered(
                            imageFilter:
                                ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                            child: Image.network(
                              product.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Center(
                            child: Hero(
                              tag: ValueKey(product.id),
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(product.title),
            Text(product.description),
            Text('\$${product.price}'),
          ],
        ),
      ),
    );
  }
}
