import 'package:flutter/material.dart';
import 'package:my_shop/providers/Cart.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    // instead of Provide.of, we can use Consumer widget
    // Consumer widget allows listening to subpart of the widget tree
    // and only that sub part gets build
    final product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.ROUTE, arguments: product.id),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavorite();
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<Cart>(
            builder: (_, cart, child) => IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addCartItem(
                  product.id,
                  product.price,
                  product.title,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
