import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/user_product_screen.dart';
import '../screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello Friend"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () => Navigator.of(context).pushReplacementNamed("/"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Order"),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrderScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () => Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),
          ),
           Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () => Provider.of<Auth>(context,listen: false).loggout(),
          ),
        ],
      ),
    );
  }
}
