import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/widget/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFav;
  const ProductGrid({
    required this.showFav,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFav ? productData.favItems : productData.items;

    if (products.isEmpty) {
      return const Center(
        child: Text('No favourites found.'),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
          key: ValueKey(index),
          // products[index].id,
          // products[index].title,
          // products[index].imageUrl,
        ),
      ),
      itemCount: products.length,
    );
  }
}
