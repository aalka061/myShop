import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.cartItems,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);
  Future<void> fetchOrders() async {
    final url =
        'https://flutter-supershop-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach(
        (orderId, orderItem) {
          loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderItem['amount'],
              dateTime: DateTime.parse(orderItem['dateTime']),
              cartItems: (orderItem['cartItems'] as List<dynamic>)
                  .map(
                    (cartItem) => CartItem(
                      id: cartItem['id'],
                      title: cartItem['title'],
                      quantity: cartItem['quantity'],
                      price: cartItem['price'],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final url =
        'https://flutter-supershop-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'cartItems': cartItems
                .map(
                  (e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  },
                )
                .toList(),
          },
        ),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          cartItems: cartItems,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
