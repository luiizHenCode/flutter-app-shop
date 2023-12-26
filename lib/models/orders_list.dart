import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/utils/base_url.dart';

class OrdersList with ChangeNotifier {
  final String _token;

  final String _userId;

  List<Order> _items;

  OrdersList([
    this._token = '',
    this._items = const [],
    this._userId = '',
  ]);

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> loadOrders() async {
    final List<Order> items = [];

    final response = await http.get(
      Uri.parse('${BaseUrl.urlOrders}/$_userId.json?auth=$_token'),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((orderId, order) {
      items.add(
        Order(
          id: orderId,
          total: order['total'],
          date: DateTime.parse(order['date']),
          products: (order['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              productId: item['productId'],
              name: item['name'],
              quantity: item['quantity'],
              price: item['price'],
              imageUrl: item['imageUrl'],
            );
          }).toList(),
        ),
      );
    });

    _items = items.reversed.toList();

    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    await http.post(
      Uri.parse('${BaseUrl.urlOrders}/$_userId.json?auth=$_token'),
      body: jsonEncode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                  'imageUrl': cartItem.imageUrl,
                })
            .toList(),
      }),
    );

    notifyListeners();
  }
}
