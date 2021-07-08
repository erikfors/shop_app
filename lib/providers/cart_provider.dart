import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.title,
    required this.id,
    required this.price,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          quantity: existing.quantity + 1,
          price: existing.price,
          title: existing.title,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          quantity: 1,
          price: price,
          title: title,
        ),
      );
    }

    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }
}
