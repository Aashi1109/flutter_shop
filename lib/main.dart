import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screen/add_new_product_screen.dart';
import 'package:shop/screen/user_product.dart';

import '../provider/orders.dart';
import './screen/cart_screen.dart';
import './screen/orders_screen.dart';
import './provider/cart.dart';
import './provider/products.dart';
import '../screen/product_detail_screen.dart';
import './screen/product_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        ),
      ],
      child: MaterialApp(
        title: 'Shopee',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        home: const ProductOverviewScreen(),
        routes: {
          CartScreen.namedRoute: (_) => CartScreen(),
          UserProduct.namedRoute: (_) => UserProduct(),
          ProductDetailScreen.namedRoute: (_) => const ProductDetailScreen(),
          OrdersScreen.namedRoute: (_) => OrdersScreen(),
          AddNewProduct.namedRoute: (_) => AddNewProduct(),
        },
      ),
    );
  }
}

// class Shop extends StatelessWidget {
//   const Shop({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ShoppeCen'),
//       ),
//       body: Center(
//         child: Text('Start by doing something'),
//       ),
//     );
//   }
// }
