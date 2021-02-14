import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart' show Orders;
import 'package:my_shop/widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const ROUTE = '/orders_screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

// We changed this widget to statful just because we want to use initState
// to update data
class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (_) {
        setState(() {
          _isLoading = true;
        });
        Provider.of<Orders>(context, listen: false).fetchOrders().then(
          (_) {
            setState(() {
              _isLoading = false;
            });
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<Orders>(context, listen: false).fetchOrders(),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: ordersProvider.orders.length,
                itemBuilder: (ctx, i) => OrderItem(ordersProvider.orders[i]),
              ),
      ),
    );
  }
}
