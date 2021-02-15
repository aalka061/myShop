import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/models/http_exception.dart';
import 'dart:convert';

import './product.dart';

// make sure you call notifiy listeners to rebuilt the widgets that are interesed in our data here
// any mehtod that manuplates products, shall be placed in products provider.
// Most of the time, you would want to reset settings selected by user when a user
// goes to another screen
class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoriesOnly = false;

  final String authToken;

  Products(this.authToken, this._items);

  List<Product> get items {
    // if (_showFavoriesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product) async {
    //async makes the method always returns future

    final baseUrl =
        'https://flutter-supershop-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        baseUrl,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite
          },
        ),
      );
      // this code won't excute till post request above is done
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    // go to the product index that we are trying to edit
    final prodIndex = _items.indexWhere((prod) => prod.id == product.id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-supershop-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          },
        ),
      );
      _items[prodIndex] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == product.id);
    var existingProduct = _items[prodIndex];

    if (prodIndex >= 0) {
      final url =
          'https://flutter-supershop-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken';

      _items.removeAt(prodIndex);
      notifyListeners();

      final response = await http.delete(url);
      // rollback if there is an error
      if (response.statusCode >= 400) {
        _items.insert(prodIndex, existingProduct);
        notifyListeners();
        throw HttpException("Could not delete product");
      }

      existingProduct = null;
    }
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchProducts() async {
    final url =
        'https://flutter-supershop-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loaddedProducts = [];
      if (extractedData == null) {
        return;
      }
      // key: id
      // value: product data
      extractedData.forEach(
        (productId, productAttributes) {
          loaddedProducts.add(
            Product(
              id: productId,
              title: productAttributes['title'],
              description: productAttributes['description'],
              price: productAttributes['price'],
              imageUrl: productAttributes['imageUrl'],
              isFavorite: productAttributes['isFavorite'],
            ),
          );
        },
      );
      _items = loaddedProducts;
      notifyListeners();
    } catch (e) {}
  }
}
