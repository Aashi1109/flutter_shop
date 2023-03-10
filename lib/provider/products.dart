import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  final String tokenId;
  late Uri serverUrl;
  final String userId;
  Products(
    this.tokenId,
    this.userId,
    this._items,
  ) {
    serverUrl = Uri.parse(
        'https://flutter-shop-7fdbf-default-rtdb.firebaseio.com/products.json?auth=$tokenId');
    // print(serverUrl);
  }

  // String dumUrl = ;
  // List<String> _curUserItems = [];
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Future<void> addProduct(Product productData) async {
    final jsonProductData = jsonEncode({
      'title': productData.title,
      'description': productData.description,
      'price': productData.price,
      'imageUrl': productData.imageUrl,
      'userId': userId,
      // 'isFavourite': productData.isFavourite,
    });

    try {
      final response = await http.post(serverUrl, body: jsonProductData);
      // print(response.body);
      _items.add(Product(
        id: jsonDecode(response.body)["name"],
        title: productData.title,
        imageUrl: productData.imageUrl,
        description: productData.description,
        price: productData.price,
      ));
      notifyListeners();
    } catch (err) {
      // print('Error occured in $err');
      rethrow;
    }
  }

  Future<void> removeProduct(String productId) async {
    final existingProductIndex =
        _items.indexWhere((product) => product.id == productId);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    // Deletion login
    final deleteUrl = Uri.parse(
        'https://flutter-shop-7fdbf-default-rtdb.firebaseio.com/products/$productId.json?auth=$tokenId');
    final delResp = await http.delete(deleteUrl);
    // print(delResp.body);
    if (delResp.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      print('in if block');
      notifyListeners();
      throw const HttpException('Error in deleting product');
    } else {
      existingProduct = null;
    }
  }

  Product getProductById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> updateProduct(String productId, Product newProductData) async {
    final foundProductIndex =
        _items.indexWhere((product) => product.id == productId);
    if (foundProductIndex >= 0) {
      final patchUrl = Uri.parse(
          'https://flutter-shop-7fdbf-default-rtdb.firebaseio.com/products/$productId.json?auth=$tokenId');

      await http.patch(patchUrl,
          body: jsonEncode({
            'title': newProductData.title,
            'price': newProductData.price,
            'description': newProductData.description,
            'imageUrl': newProductData.imageUrl,
          }));
      _items[foundProductIndex] = Product(
        id: productId,
        title: newProductData.title,
        imageUrl: newProductData.imageUrl,
        description: newProductData.description,
        price: newProductData.price,
        userId: newProductData.userId ?? '',
      );
      notifyListeners();
    } else {
      // print('Update product failed');
    }
  }

  Future<void> fetchProducts() async {
    try {
      // print(serverUrl.toString());
      final favUrl = Uri.parse(
          'https://flutter-shop-7fdbf-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$tokenId');

      final data = await http.get(serverUrl);
      // print(data.body);
      final fetchedData = jsonDecode(data.body) as Map<String, dynamic>;

      if (fetchedData['error'] != null) {
        throw HttpException(fetchedData['error']);
      }
      final favListResp = await http.get(favUrl);
      final favList = jsonDecode(favListResp.body);
      // print(favListResp.body);
      // print(fetchedData);
      List<Product> loadedProducts = [];
      // print(fetchedData);

      fetchedData.forEach((id, prodData) {
        // print(prodData['price']);
        loadedProducts.add(Product(
          id: id,
          title: prodData["title"],
          description: prodData["description"],
          price: prodData["price"],
          imageUrl: prodData["imageUrl"],
          userId: prodData['userId'] ?? '',
          isFavourite: favList == null
              ? false
              : favList[id] == null
                  ? false
                  : favList[id]['isFavourite'] ?? false,
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  List<Product> get curUserProd {
    return _items.where((prod) => prod.userId == userId).toList();
  }
}
