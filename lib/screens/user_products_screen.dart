import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
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
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.ROUTE);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: productsProvider.items.length,
        itemBuilder: (_, i) => UserProductItem(productsProvider.items[i]),
      ),
    );
  }
}
