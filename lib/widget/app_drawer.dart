import 'package:flutter/material.dart';
import 'package:shop/screen/user_product.dart';

import '../screen/orders_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello, Shopper'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopify_outlined),
            title: const Text('Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.namedRoute);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('User Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProduct.namedRoute);
            },
          ),
        ],
      ),
    );
  }
}
