import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

//ignore: must_be_immutable
class OrderButton extends StatefulWidget {
  OrderButton({
    Key? key,
    required this.cart,
    this.isLoading = false,
  }) : super(key: key);

  final cart;
  var isLoading;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || widget.isLoading)
          ? null
          : () async {
              setState(() {
                widget.isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              widget.cart.clear();
              setState(() {
                widget.isLoading = false;
              });
            },
      child: widget.isLoading
          ? CircularProgressIndicator()
          : Text(
              "ORDER NOW",
            ),
    );
  }
}
