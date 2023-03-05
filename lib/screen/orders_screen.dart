import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widget/app_drawer.dart';
import 'package:shop/widget/order_item.dart';

import '../provider/orders.dart' show Order;

class OrdersScreen extends StatelessWidget {
  static const namedRoute = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      drawer: const MainDrawer(),
      body: orderProvider.orders.isEmpty
          ? const Center(
              child: Text('No order found.'),
            )
          : Container(
              padding: const EdgeInsets.all(15),
              child: ListView(
                children: orderProvider.orders
                    .map((order) => OrderItem(
                          orderItem: order,
                        ))
                    .toList(),
              ),
            ),
    );
  }
}
