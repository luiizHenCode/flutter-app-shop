import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/base_url.dart';

class ProductsList with ChangeNotifier {
  final String _token;

  final String userId;

  final List<Product> _items;

  ProductsList([
    this._token = '',
    this.userId = '',
    this._items = const [],
  ]);

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((p) => p.isFavorite).toList();

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${BaseUrl.urlProducts}.json?auth=$_token'),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    final favResponse = await http.get(
      Uri.parse('${BaseUrl.urlFavorites}/$userId.json?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    data.forEach((productId, product) {
      _items.add(
        Product(
          id: productId,
          name: product['name'],
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
          isFavorite: favData[productId] ?? false,
        ),
      );
    });

    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data.containsKey('id');

    String id = hasId ? data['id'] as String : "p${_items.length + 1}";

    final Product product = Product(
      id: id,
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${BaseUrl.urlProducts}.json?auth=$_token'),
      body: jsonEncode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
    );

    String id = jsonDecode(response.body)['name'];

    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );

    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${BaseUrl.urlProducts}/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];

      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
          Uri.parse('${BaseUrl.urlProducts}/${product.id}.json?auth=$_token'));

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();

        throw HttpException(
          msg: 'Ocorreu um erro na exclusão do produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }

  Future<void> toggleFavorite(Product product) async {
    product.toggleFavorite();
    notifyListeners();

    final response = await http.put(
      Uri.parse(
        '${BaseUrl.urlFavorites}/$userId/${product.id}.json?auth=$_token',
      ),
      body: jsonEncode(product.isFavorite),
    );

    if (response.statusCode >= 400) {
      product.toggleFavorite();
      notifyListeners();

      throw HttpException(
        msg: 'Não foi possível atualizar o status do produto.',
        statusCode: response.statusCode,
      );
    }
  }
}
