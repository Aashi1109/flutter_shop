import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screen/add_new_product_screen.dart';
import './screen/auth_screen.dart';
import './screen/user_product.dart';
import '../provider/orders.dart';
import './screen/cart_screen.dart';
import './screen/orders_screen.dart';
import './provider/cart.dart';
import './provider/products.dart';
import '../screen/product_detail_screen.dart';
import './screen/product_overview_screen.dart';
import './provider/auth.dart';
import './widget/splash_screen.dart';
import './helpers/custom_route.dart';

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
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products('', '', []),
            update: (context, authData, previousProducts) {
              // print(authData.token);
              return Products(authData.token ?? '', authData.curUserId,
                  previousProducts!.items);
            }),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (context) => Order('', '', []),
          update: (_, authProv, prevOrder) => Order(
              authProv.token ?? '', authProv.curUserId, prevOrder!.orders),
        ),
      ],
      child: MaterialApp(
        title: 'Shopee',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange, tertiary: Colors.white),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            })),

        // home: const ProductOverviewScreen(),
        home: Consumer<Auth>(builder: (ctx, authProvider, ch) {
          // print(authProvider.isAuth);
          // return AuthScreen();
          return authProvider.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: authProvider.autoLogin(),
                  builder: (context, dataSnapshot) =>
                      dataSnapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen());
        }),
        routes: {
          CartScreen.namedRoute: (_) => const CartScreen(),
          UserProduct.namedRoute: (_) => const UserProduct(),
          ProductDetailScreen.namedRoute: (_) => const ProductDetailScreen(),
          OrdersScreen.namedRoute: (_) => const OrdersScreen(),
          AddNewProduct.namedRoute: (_) => const AddNewProduct(),
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
