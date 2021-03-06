import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exeption.dart';
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  String? authToken;
  String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavorites) {
    //   return _items.where((product) => product.isFavorite).toList();
    // }
    return [..._items];
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var params = filterByUser ? {
      'auth': authToken,
      'equalTo': json.encode(userId),
      "orderBy":json.encode("creatorId"),
    } : {
      'auth': authToken,
    };

    final url = Uri.https("flutter-shop-f46a1-default-rtdb.firebaseio.com",
        "products.json", params);

    final urlFav = Uri.https("flutter-shop-f46a1-default-rtdb.firebaseio.com",
        "userFavorites/$userId.json", params);

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final favoriteResponse = await http.get(urlFav);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];

      extractedData.forEach((prodID, productData) {
        loadedProducts.add(
          Product(
            id: prodID,
            title: productData["title"],
            description: productData["description"],
            imageUrl: productData["imageUrl"],
            price: productData["price"],
            isFavorite: favoriteData == null ? false : favoriteData[prodID] ?? false,
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
    var params = {
      'auth': authToken,
    };
    final url = Uri.https("flutter-shop-f46a1-default-rtdb.firebaseio.com",
        "products.json", params);

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "creatorId": userId,
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

  Future<void> editProduct(String id, Product product) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex < 0) {
      return;
    }
    var params = {
      'auth': authToken,
    };
    final url = Uri.https("flutter-shop-f46a1-default-rtdb.firebaseio.com",
        "products/$id.json", params);
    await http.patch(
      url,
      body: json.encode({
        "title": product.title,
        "description": product.description,
        "imageUrl": product.imageUrl,
        "price": product.price,
      }),
    );
    _items[prodIndex] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    var params = {
      'auth': authToken,
    };
    final url = Uri.https("flutter-shop-f46a1-default-rtdb.firebaseio.com",
        "products/$id.json", params);
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }
    existingProduct = null;
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
