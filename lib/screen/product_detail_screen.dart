import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../provider/cart.dart';

import '../provider/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const namedRoute = 'product-detail';
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as String;
    final productId = routeArgs;
    final productData = Provider.of<Products>(context, listen: false);
    final authProvider = Provider.of<Auth>(context, listen: false);
    final cartProvider = Provider.of<Cart>(context, listen: false);
    final products = productData.items;
    final foundProduct =
        products.firstWhere((product) => product.id == productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(foundProduct.title),
        actions: foundProduct.userId == authProvider.curUserId
            ? [
                IconButton(
                  onPressed: () async {
                    productData.removeProduct(foundProduct.id);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.delete,
                    // color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ]
            : [],
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      foundProduct.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        foundProduct.isFavourite
                            ? Icons.favorite_outlined
                            : Icons.favorite_border_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () async {
                        await foundProduct.toogleFavourite(
                            authProvider.token ?? '', authProvider.curUserId);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(foundProduct.description), const SizedBox(height: 10),
                // TextSpan(children: []),
                // Text(
                //   'Price: \$${foundProduct.price.toString()}',
                //   style: TextStyle(
                //     fontSize: 15,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Text.rich(TextSpan(
                    // style: TextStyle(color: Colors.redAccent), //apply style to all
                    children: [
                      const TextSpan(
                        text: 'Price: ',
                        // style: TextStyle(),
                      ),
                      TextSpan(
                        text: '\$${foundProduct.price.toString()}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ])),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    cartProvider.addCartitem(foundProduct.id,
                        foundProduct.title, foundProduct.price);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
