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
  final _form = GlobalKey<FormState>();
  var firstRun = true;
  var productUrl = '';
  var product =
      Product(id: '', title: '', description: '', price: 0.0, imageUrl: '');
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<Products>(context);
    if (firstRun) {
      final String? productId =
          ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null && firstRun) {
        final editedProduct = productsProvider.findById(productId);
        product = product.copyWith(
            id: editedProduct.id,
            title: editedProduct.title,
            description: editedProduct.description,
            price: editedProduct.price,
            imageUrl: editedProduct.imageUrl,
            isFavorite: editedProduct.isFavorite);
        productUrl = editedProduct.imageUrl;
        firstRun = false;
      }
    }
    void _saveForm() async {
      final isValid = _form.currentState!.validate();
      if (!isValid) {
        return;
      }
      _form.currentState?.save();
      setState(() {
        isLoading = true;
      });
      try {
        await productsProvider.addProduct(product);
      } catch (error) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('An Error Occurred'))
                  ],
                ));
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: product.title,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          product =
                              product.copyWith(id: product.id, title: value);
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Field is Empty' : null;
                        },
                      ),
                      TextFormField(
                        initialValue: product.description,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        validator: (value) {
                          return value!.isEmpty ? 'Field is Empty' : null;
                        },
                        onSaved: (value) {
                          product = product.copyWith(
                              id: product.id, description: value);
                        },
                      ),
                      TextFormField(
                        initialValue: product.price.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          product = product.copyWith(
                              id: product.id,
                              price: double.tryParse(value!.trim()) ?? 0.0);
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Field is Empty' : null;
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
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: productUrl.isEmpty
                                ? const Text('Enter a URL')
                                : Image.network(
                                    productUrl,
                                    errorBuilder: (context, object, trace) =>
                                        const Text('Enter a Valid URL'),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: product.imageUrl,
                              keyboardType: TextInputType.url,
                              decoration: const InputDecoration(
                                  labelText: 'Select Image'),
                              textInputAction: TextInputAction.done,
                              onChanged: (newValue) => setState(() {
                                product = product.copyWith(
                                    id: product.id, imageUrl: newValue);
                                productUrl = newValue;
                                print(productUrl);
                              }),
                              onSaved: (value) {
                                product = product.copyWith(imageUrl: value);
                              },
                              validator: (value) {
                                return value!.isEmpty ? 'Field is Empty' : null;
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
