import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;
  final String userId;

  Orders(this.authToken,this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSet() async {
     var params = {
      'auth': authToken,
    };
    final url = Uri.https(
        "flutter-shop-f46a1-default-rtdb.firebaseio.com", "orders/$userId.json",params);

    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;


    // if (extractedData == null) {
    //   return;
    // }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData["amount"],
          dateTime: DateTime.parse(
            orderData["date"],
          ),
          products: (orderData["products"] as List<dynamic>)
              .map(
                (items) => CartItem(
                  id: items["id"],
                  price: items["price"],
                  title: items["title"],
                  quantity: items["quantity"],
                ),
              )
              .toList(),
        ),
      );
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var params = {
      'auth': authToken,
    };
    final url = Uri.https(
        "flutter-shop-f46a1-default-rtdb.firebaseio.com", "orders/$userId.json",params);

    final date = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "amount": total,
          "date": date.toIso8601String(),
          "products": cartProducts
              .map((cartItem) => {
                    "id": cartItem.id,
                    "title": cartItem.title,
                    "price": cartItem.price,
                    "quantity": cartItem.quantity,
                  })
              .toList(),
        }),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)["name"],
          products: cartProducts,
          amount: total,
          dateTime: date,
        ),
      );

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
