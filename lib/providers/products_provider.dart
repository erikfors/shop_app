import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    // if (_showFavorites) {
    //   return _items.where((product) => product.isFavorite).toList();
    // }
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        "flutter-shop-f46a1-default-rtdb.firebaseio.com", "products.json");

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodID, productData) {
        loadedProducts.add(
          Product(
            id: prodID,
            title: productData["title"],
            description: productData["description"],
            imageUrl: productData["imageUrl"],
            price: productData["price"],
            isFavorite: productData["isFavorite"],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Product> get favoriteitems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        "flutter-shop-f46a1-default-rtdb.firebaseio.com", "products.json");

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isFavorite": product.isFavorite,
        }),
      );

      final newProduct = Product(
        description: product.description,
        isFavorite: false,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)["name"],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void editProduct(String id, Product product) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex < 0) {
      return;
    }
    _items[prodIndex] = product;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  Product findById(String id) {
    return items.firstWhere(
      (product) => product.id == id,
    );
  }

  // void showFavoritesOnly() {
  //   _showFavorites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavorites = false;
  //   notifyListeners();
  // }
}
