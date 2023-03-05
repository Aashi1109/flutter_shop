import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const namedRoute = 'product-detail';
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as String;
    final productId = routeArgs;
    final productData = Provider.of<Products>(context, listen: false);
    final products = productData.items;
    final foundProduct =
        products.firstWhere((product) => product.id == productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(foundProduct.title),
      ),
      body: Column(
        children: [
          Image.network(
            foundProduct.imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            foundProduct.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(foundProduct.description),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
