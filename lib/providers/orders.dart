import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  List<OrderItem> _orders = [];
  Orders(this.authToken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-update-1-d50a4-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price']))
                .toList()),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-update-1-d50a4-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                    })
                .toList(),
            'dateTime': timestamp.toIso8601String()
          }));

      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProducts,
              dateTime: timestamp));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
