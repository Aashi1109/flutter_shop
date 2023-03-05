import 'package:flutter/foundation.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem({
    required this.id,
    required this.price,
    required this.products,
    required this.orderDate,
  });
}

class Order with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get ordersLength {
    return _orders.length;
  }

  void addOrder(List<CartItem> orderData, double amount) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        price: amount,
        products: orderData,
        orderDate: DateTime.now(),
      ),
    );
  }
}
