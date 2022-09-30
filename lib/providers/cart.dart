import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  final String url =
      'https://flutter-update-1-d50a4-default-rtdb.firebaseio.com/cart.json';
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  Future<void> addItem(
    String productId,
    double price,
    String title,
  ) async {
    if (_items.containsKey(productId)) {
      //change quantity
      final response = await http.get(Uri.parse(url));
      if (response.statusCode >= 400) {
        throw HttpException('server error exception');
      }
      //CartItem cartItem = json.decode(response.body) as CartItem;

      // final response = await http.patch(Uri.parse(url),
      //     body: json.encode({'title': title, 'quantity': 1, 'price': price}));
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity + 1,
                price: existingCartItem.price,
              ));
    } else {
      var product = {};
      product[productId] = {'title': title, 'quantity': 1, 'price': price};

      final response =
          await http.post(Uri.parse(url), body: json.encode(product));
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: json.decode(response.body)['name'],
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    final url =
        'https://flutter-update-1-d50a4-default-rtdb.firebaseio.com/cart/$productId';
    final existingCart = _items.containsKey(productId);
    var existingCartItem = _items[productId];
    if (existingCart) {
      _items.remove(existingCartItem);
      notifyListeners();
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode > 400) {
        _items.putIfAbsent(productId, () => existingCartItem);
        notifyListeners();
        throw HttpException('cannot remove cart item');
      } else {
        existingCartItem = null;
      }
    } else {
      throw HttpException('cannot find cart item');
    }
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity - 1,
                price: existingCartItem.price,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
