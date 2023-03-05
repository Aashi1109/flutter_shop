import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/widget/app_drawer.dart';

import '../widget/badge.dart';
import './cart_screen.dart';

import '../widget/product_grid.dart';

enum MenuFilters { Favourite, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  // final List<Product> loadedProducts= DUMMY_PRODUCTS;
  bool _showFavorite = false;
  @override
  Widget build(BuildContext context) {
    // final cartData = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Consumer<Cart>(
            builder: (_, cartData, ch) {
              // print(cartData);
              return CustomBadge(
                value: cartData.cartLength.toString(),
                child: ch!,
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.namedRoute);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            onSelected: (MenuFilters value) {
              setState(() {
                switch (value) {
                  case MenuFilters.All:
                    _showFavorite = false;
                    break;
                  case MenuFilters.Favourite:
                    _showFavorite = true;
                    break;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: MenuFilters.Favourite,
                child: Text('Favourites'),
              ),
              const PopupMenuItem(
                value: MenuFilters.All,
                child: Text('All'),
              ),
            ],
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: ProductGrid(showFav: _showFavorite),
      drawer: const MainDrawer(),
    );
  }
}
