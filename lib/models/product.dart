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
  String? userId;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    this.userId,
    this.isFavourite = false,
  });

  Future<void> toogleFavourite(String token, String userId) async {
    bool oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final serverUrl = Uri.parse(
        'https://flutter-shop-7fdbf-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token');
    try {
      // print(serverUrl.toString());
      final patchResp = await http.put(
        serverUrl,
        body: jsonEncode({
          'isFavourite': isFavourite,
        }),
      );

      // print(patchResp.body);
      if (patchResp.statusCode >= 400) {
        throw const HttpException('Error changing favourite');
      }
    } catch (err) {
      // print(err);
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
