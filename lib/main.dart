import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:my_shop/screens/products_overview_screen.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

// use ChangeNotifierProvider , builder when instantite data for first time
// user ChangeNotifierProvider.value when you want to work with an existing data
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          '/': (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.ROUTE: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
