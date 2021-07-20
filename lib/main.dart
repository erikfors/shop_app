import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import '../screens/order_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart_provider.dart';
import './screens/product_overview_screen.dart';
import './screens/prooduct_detail_screen.dart';
import './providers/products_provider.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_sceen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, previous) => ProductsProvider(
              auth.token, auth.userId, previous == null ? [] : previous.items),
          create: (ctx) => ProductsProvider("", "", []),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previous) => Orders(
              auth.token, auth.userId, previous == null ? [] : previous.orders),
          create: (ctx) => Orders("", "", []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: "Lato"),
          home: authData.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  builder: (ctx, authSnapShot) =>
                      authSnapShot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                  future: authData.tryAutoLogin(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditAddProductScreen.routeName: (ctx) => EditAddProductScreen(),
          },
        ),
      ),
    );
  }
}
