import 'package:flutter/material.dart';
import '../providers/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const ROUTE = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text("Your cart"),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline1
                              .color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        );
                        cart.clear();
                      },
                      child: Text('ORDER now'),
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                  itemCount: cart.itemsCount,
                  itemBuilder: (ctx, index) => CartItem(
                        id: cart.items.values.toList()[index].id,
                        title: cart.items.values.toList()[index].title,
                        quantity: cart.items.values.toList()[index].quantity,
                        price: cart.items.values.toList()[index].price,
                        productId: cart.items.keys.toList()[index],
                      )),
            )
          ],
        ));
  }
}
