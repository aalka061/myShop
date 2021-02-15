import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:provider/provider.dart';

import './providers/orders.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';

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
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        )
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
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
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
