import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  static const productTitleTextStyle =
      TextStyle(fontFamily: 'Anton', fontSize: 20);
  static const productPriceTextStyle = TextStyle(fontFamily: 'Lato');
  static const productQuantityTextStyle =
      TextStyle(fontFamily: 'Lato', fontSize: 12);

  const CartItemWidget({Key? key}) : super(key: key);

//todo: you could add a sub total for each cart item
  @override
  Widget build(BuildContext context) {
    CartItem cartItem = Provider.of<CartItem>(context);
    Cart cart = Provider.of<Cart>(context);
    return Container(
      margin: const EdgeInsets.all(10),
      child: Dismissible(
        key: ValueKey(cartItem.product.id),
        background: Container(
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: const Icon(
            Icons.delete,
            size: 40,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_){
          cart.removeItem(cartItem);
        },
        child: Card(
          color: const Color.fromRGBO(198, 228, 247, 1),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          cartItem.product.imageUrl,
                          height: 108,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: TextButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(198, 228, 247, 1))),
                          onPressed: () {
                            cart.removeItem(cartItem);
                            cart.refresh();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          label: const Text(
                            'Remove',
                            softWrap: false,
                            style: TextStyle(
                              color: Colors.black,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cartItem.product.title,
                          style: CartItemWidget.productTitleTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${cartItem.quantity}x  ',
                              style: CartItemWidget.productQuantityTextStyle,
                            ),
                            Text(
                              '\$${cartItem.product.price.toStringAsFixed(2)}',
                              style: CartItemWidget.productPriceTextStyle,
                            )
                          ],
                        )
                      ],
                    )),
                Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      width: 48,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              cart.refresh();
                              cartItem.increaseQuantity();
                            },
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                              onPressed: cartItem.quantity > 1
                                  ? () {
                                      cart.refresh();
                                      cartItem.decreaseQuantity();
                                    }
                                  : null,
                              icon: const Icon(Icons.remove))
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
