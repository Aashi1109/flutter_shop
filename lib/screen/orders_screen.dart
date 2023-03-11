import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/app_drawer.dart';
import '../widget/order_item.dart';
import '../provider/orders.dart' show Order;

class OrdersScreen extends StatelessWidget {
  static const namedRoute = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final orderProvider = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
          builder: (context, dataSnapshot) {
            switch (dataSnapshot.connectionState) {
              case ConnectionState.waiting:
                // print('In connection active state');
                return const Center(
                  child: CircularProgressIndicator(),
                );
              // case ConnectionState.done:
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );

              default:
                if (dataSnapshot.hasError) {
                  return Center(
                    child: Text(
                      dataSnapshot.error.toString(),
                    ),
                  );
                } else {
                  print('in data return part');
                  return Container(
                    padding: const EdgeInsets.all(15),
                    child: Consumer<Order>(builder: (ctx, orderProvider, ch) {
                      if (orderProvider.curUserOrders.isEmpty) {
                        return const Center(
                          child: Text('No orders found'),
                        );
                      }
                      return ListView(
                        children: orderProvider.curUserOrders
                            .map(
                              (order) => OrderItem(
                                orderItem: order,
                              ),
                            )
                            .toList(),
                      );
                    }),
                  );
                }
            }
          }),
    );
  }
}
