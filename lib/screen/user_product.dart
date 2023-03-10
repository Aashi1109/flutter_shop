import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../widget/app_drawer.dart';
import '../widget/user_product_item.dart';
import './add_new_product_screen.dart';

class UserProduct extends StatelessWidget {
  static const namedRoute = '/user-products';
  const UserProduct({super.key});

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    // final userProducts = productProvider;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
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
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView(
          children: productProvider.curUserProd
              .map(
                (product) => Column(
                  children: [
                    UserProductItem(
                      prodUserId: product.userId ?? '',
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
      ),
    );
  }
}
