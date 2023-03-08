import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    this.isFavourite = false,
  });

  void toogleFavourite() async {
    bool oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final serverUrl = Uri.parse(
        'https://flutter-shop-7fdbf-default-rtdb.firebaseio.com/products/$id.json');
    try {
      final patchResp = await http.patch(
        serverUrl,
        body: jsonEncode({
          'isFavourite': isFavourite,
        }),
      );
      if (patchResp.statusCode >= 400) {
        throw const HttpException('Error changing favourite');
      }
    } catch (err) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
