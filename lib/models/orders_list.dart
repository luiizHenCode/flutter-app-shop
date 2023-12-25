import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/utils/base_url.dart';

class OrdersList with ChangeNotifier {
  final String _baseUrl = '${BaseUrl.server}/orders';

  final List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> loadOrders() async {
    _items.clear();

    final response = await http.get(Uri.parse('$_baseUrl.json'));

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((orderId, order) {
      _items.add(
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

    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    await http.post(
      Uri.parse('$_baseUrl.json'),
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

    // final orderId = jsonDecode(response.body)['name'];

    // _items.insert(
    //   0,
    //   Order(
    //     id: orderId,
    //     total: cart.totalAmount,
    //     date: date,
    //     products: cart.items.values.toList(),
    //   ),
    // );

    notifyListeners();
  }
}
