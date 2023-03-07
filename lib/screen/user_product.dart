import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/widget/app_drawer.dart';
import 'package:shop/widget/user_product_item.dart';
import './add_new_product_screen.dart';

class UserProduct extends StatelessWidget {
  static const namedRoute = '/user-products';
  const UserProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddNewProduct.namedRoute);
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: ListView(
        children: productProvider.items
            .map(
              (product) => Column(
                children: [
                  UserProductItem(
                    title: product.title,
                    imageUrl: product.imageUrl,
                    id: product.id,
                  ),
                  const Divider(),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
