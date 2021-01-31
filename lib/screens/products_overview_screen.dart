import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const ROUTE = '/products_overview_screen';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {}
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Favorities Only"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("All"),
                value: FilterOptions.All,
              ),
            ],
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
