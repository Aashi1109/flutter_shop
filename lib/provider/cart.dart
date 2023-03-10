import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  // String tokenId;
  // Cart(this.tokenId);
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartLength {
    // notifyListeners();
    return _items.length;
  }

  double get cartTotalPrice {
    double total = 0;
    _items.forEach((_, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  void addCartitem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  void removeCartItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  bool isProductInCart(String productId) {
    return _items.containsKey(productId);
  }

  void undoCartItem(productId) {
    // if(_items.)
    if (_items[productId]!.quantity == 1) {
      return removeCartItem(productId);
    }
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity - 1,
        ),
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
