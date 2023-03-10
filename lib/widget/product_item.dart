import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../provider/cart.dart';
import '../models/product.dart';
import '../screen/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  const ProductItem(
      // this.id, this.title, this.imageUrl,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartProvider = Provider.of<Cart>(context, listen: false);
    final authProvider = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(product.title),
          leading: Consumer<Product>(builder: (ctx, product, _) {
            return IconButton(
              icon: Icon(
                product.isFavourite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                product.toogleFavourite(
                    authProvider.token ?? '', authProvider.curUserId);
              },
            );
          }),
          trailing: IconButton(
            onPressed: () {
              cartProvider.addCartitem(
                  product.id, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added item to cart.'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cartProvider.undoCartItem(product.id);
                    },
                  ),
                ),
              );
            },
            icon: Consumer<Cart>(builder: (_, cartData, c) {
              return Icon(
                cartData.isProductInCart(product.id)
                    ? Icons.shopping_cart
                    : Icons.add_shopping_cart_rounded,
                color: Theme.of(context).colorScheme.secondary,
              );
            }),
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.namedRoute,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
