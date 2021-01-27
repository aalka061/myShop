import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const ROUTE = '/product-detial';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Center(
        child: Text("Product Detail"),
      ),
    );
  }
}
