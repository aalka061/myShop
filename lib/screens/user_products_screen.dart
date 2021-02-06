import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const ROUTE = '/user_products_screen';

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
        itemCount: productsProvider.items.length,
        itemBuilder: (_, i) => {},
      ),
    );
  }
}
