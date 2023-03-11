import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/orders.dart';
import '../provider/cart.dart' show Cart;
import '../widget/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const namedRoute = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final orderProvider = Provider.of<Order>(context);
    final totalCartAmount = cartData.cartTotalPrice;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: totalCartAmount == 0
          ? const Center(
              child: Text('Your cart is empty.'),
            )
          : Column(
              children: [
                if (totalCartAmount != 0)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: ListView.builder(
                        itemBuilder: (context, index) => CartItem(
                          productId: cartData.items.keys.toList()[index],
                          id: cartData.items.values.toList()[index].id,
                          title: cartData.items.values.toList()[index].title,
                          quantity:
                              cartData.items.values.toList()[index].quantity,
                          price: cartData.items.values.toList()[index].price,
                        ),
                        itemCount: cartData.items.length,
                      ),
                    ),
                  ),
                // const SizedBox(
                //   width: 20,
                // ),
                if (totalCartAmount != 0)
                  Card(
                    margin: const EdgeInsets.all(15),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          const Spacer(),
                          Chip(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            label: Text(
                              '\$${totalCartAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .titleLarge!
                                      .color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // const Spacer(),
                if (totalCartAmount != 0)
                  OrderButton(orderProvider: orderProvider, cartData: cartData),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.orderProvider,
    required this.cartData,
  });

  final Order orderProvider;
  final Cart cartData;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await widget.orderProvider
                    .addOrder(widget.cartData.items.values.toList(),
                        widget.cartData.cartTotalPrice)
                    .catchError((err) {
                  print(err);
                }).then((value) {
                  widget.cartData.clearCart();
                });
              },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Order Now'),
      ),
    );
  }
}
