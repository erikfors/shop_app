import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/orders";
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    final orderItems = orderData.orders;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "Your orders",
        ),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, index) => OrderItemWidget(
          orderItems[index],
        ),
      ),
    );
  }
}
