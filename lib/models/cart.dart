import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemsCount {
    int count = 0;

    _items.forEach((key, cartItem) {
      count += cartItem.quantity;
    });

    return count;
  }

  int get uniqueItensCart => _items.length;

  int countByItem(String productId) {
    int count = 0;

    _items.forEach((key, cartItem) {
      if (cartItem.productId == productId) {
        count += cartItem.quantity;
      }
    });

    return count;
  }

  double get totalAmount {
    double total = 0.0;

    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  String get totalAmountString {
    return "R\$ ${totalAmount.toStringAsFixed(2)}";
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: product.id,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          imageUrl: existingItem.imageUrl,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantity: 1,
          imageUrl: product.imageUrl,
          price: product.price,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity == 1) {
        _items.remove(productId);
        notifyListeners();
        return;
      }

      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: existingItem.quantity - 1,
          imageUrl: existingItem.imageUrl,
          price: existingItem.price,
        ),
      );
    }

    notifyListeners();
  }

  void incrementQtd(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          imageUrl: existingItem.imageUrl,
          price: existingItem.price,
        ),
      );
    }

    notifyListeners();
  }

  void decrementQtd(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity == 1) {
        _items.remove(productId);
        notifyListeners();
        return;
      }

      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: existingItem.quantity - 1,
          imageUrl: existingItem.imageUrl,
          price: existingItem.price,
        ),
      );
    }

    notifyListeners();
  }

  void clear() {
    _items.clear();

    notifyListeners();
  }
}
