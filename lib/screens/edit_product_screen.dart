import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit_product_screen';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  String imageUrl = '';
  final _form = GlobalKey<FormState>();
  var product = Product(title: '', description: '', price: 0, imageUrl: '');

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<Products>(context);
    void _saveForm() {
      _form.currentState?.save();
      products.addProduct(product);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    product = product.copyWith(title: value);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  onSaved: (value) {
                    product = product.copyWith(description: value);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    product = product.copyWith(
                        price: double.tryParse(value!.trim()) ?? 0.0);
                  },
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: imageUrl.isEmpty
                          ? const Text('Enter a URL')
                          : Image.network(
                              imageUrl,
                              errorBuilder: (context, object, trace) =>
                                  const Text('Enter a Valid URL'),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: imageUrl,
                        keyboardType: TextInputType.url,
                        decoration:
                            const InputDecoration(labelText: 'Select Image'),
                        textInputAction: TextInputAction.done,
                        onChanged: (newValue) => setState(() {
                          imageUrl = newValue;
                        }),
                        onSaved: (value) {
                          product = product.copyWith(imageUrl: value);
                        },
                        onFieldSubmitted: (_) => _saveForm(),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
