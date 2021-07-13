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
    // final orderData = Provider.of<Orders>(context);
    // final orderItems = orderData.orders;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "Your orders",
        ),
      ),
      body: FutureBuilder(
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapShot.error != null) {
            //error handling
            return Center(
              child: Text("There is no orders."),
            );
          } else {
            return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, index) => OrderItemWidget(
                        orderData.orders[index],
                      ),
                    ));
          }
        },
        future: Provider.of<Orders>(context, listen: false).fetchAndSet(),
      ),
    );
  }
}
