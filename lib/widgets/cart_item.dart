import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItemWidget({
    required this.quantity,
    required this.price,
    required this.title,
    required this.id,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    

    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<CartProvider>(context, listen: false).removeItem(productId);
      },
      key: ValueKey(id),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("\$$price"),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total: \$${(price * quantity)}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
