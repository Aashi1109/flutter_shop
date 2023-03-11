import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> products;
  final DateTime orderDate;
  String userId;

  OrderItem({
    required this.id,
    required this.price,
    required this.products,
    required this.orderDate,
    this.userId = '',
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  late Uri postUrl;
  String _tokenId = '';
  String _userId = '';

  Order(String tokenId, String userId, this._orders) {
    _tokenId = tokenId;
    _userId = userId;
    postUrl = Uri.parse(
        'https://flutter-shop-7fdbf-default-rtdb.firebaseio.com/orders.json?auth=$tokenId');
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get ordersLength {
    return _orders.length;
  }

  Future<void> fetchAndSetOrders() async {
    final getResp = await http.get(postUrl);
    // print(getResp.body);
    final receivedOrders = jsonDecode(getResp.body) as Map<String, dynamic>?;
    if (receivedOrders != null) {
      // print(receivedOrders);
      List<OrderItem> loadedOrders = [];

      receivedOrders.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            price: orderData['price'],
            userId: orderData['userId'] ?? '',
            products: (orderData['products'] as List<dynamic>).map((cartItem) {
              // print(cartItem);
              return CartItem(
                  id: DateTime.parse(cartItem['id']).toString(),
                  // id: '',
                  title: cartItem['title'],
                  quantity: cartItem['quantity'],
                  price: cartItem['price']);
            }).toList(),
            orderDate: DateTime.parse(orderData['orderDate']),
          ),
        );
      });

      _orders = loadedOrders;
      notifyListeners();
    }
  }

  Future<void> addOrder(List<CartItem> orderData, double amount) async {
    final postResp = await http.post(postUrl,
        body: jsonEncode({
          'price': amount,
          'orderDate': DateTime.now().toIso8601String(),
          'userId': _userId,
          'products': orderData
              .map(
                (cartItem) => {
                  'id': cartItem.id,
                  'price': cartItem.price,
                  'quantity': cartItem.quantity,
                  'title': cartItem.title
                },
              )
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: jsonDecode(postResp.body)['name'],
        price: amount,
        products: orderData,
        orderDate: DateTime.now(),
      ),
    );
  }

  List<OrderItem> get curUserOrders {
    return _orders.where((order) => order.userId == _userId).toList();
  }
}
