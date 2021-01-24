import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../widgets/product_item.dart';

import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const ROUTE = '/products_overview_screen';

  final List<Product> loadedProducts = dummyProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: loadedProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) => ProductItem(
          loadedProducts[index].id,
          loadedProducts[index].title,
          loadedProducts[index].imageUrl,
        ),
      ),
    );
  }
}
