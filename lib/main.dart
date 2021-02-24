import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/orders.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';

void main() {
  runApp(MyApp());
}

// use ChangeNotifierProvider , builder when instantite data for first time
// user ChangeNotifierProvider.value when you want to work with an existing data
// since we are going to use Cart data in so many screens, it makes sense we register
// cart data provider in the main widget
// Multiple providers: class takes list of providers
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        // Dependecy injection
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (context, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          // authenticated: go to product overview screen
          // not authentication: go auth screen
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResulSnapShot) =>
                      authResulSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductsOverviewScreen.ROUTE: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.ROUTE: (ctx) => ProductDetailScreen(),
            CartScreen.ROUTE: (ctx) => CartScreen(),
            OrdersScreen.ROUTE: (ctx) => OrdersScreen(),
            UserProductsScreen.ROUTE: (ctx) => UserProductsScreen(),
            EditProductScreen.ROUTE: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
