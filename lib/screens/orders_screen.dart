import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart' show Orders;
import 'package:my_shop/widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const ROUTE = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (ctx, i) => OrderItem(ordersProvider.orders[i]),
      ),
    );
  }
}
