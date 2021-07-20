import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exeption.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.description,
    required this.id,
    required this.imageUrl,
    this.isFavorite = false,
    required this.price,
    required this.title,
  });

  Future<void> toggleFavoriteStatus(String? token, String userID) async {
     var params = {
      'auth': token,
    };
    final url = Uri.https(
        "flutter-shop-f46a1-default-rtdb.firebaseio.com", "userFavorites/$userID/$id.json",params);
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException("Failed to change favorite status");
    }
  }
}
