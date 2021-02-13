import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final snakScafold = ScaffoldMessenger.of(context);

    return Card(
      elevation: 10,
      child: ListTile(
        title: Text(this.product.title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.ROUTE, arguments: product);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .removeProduct(product);
                  } catch (e) {
                    snakScafold.showSnackBar(
                      SnackBar(content: Text("Deleting failed!")),
                    );
                  }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
