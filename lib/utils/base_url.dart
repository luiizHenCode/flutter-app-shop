class BaseUrl {
  static String server =
      'https://flutter-shop-634c6-default-rtdb.firebaseio.com';

  static String get urlProducts => '$server/products';

  static String get urlOrders => '$server/orders';

  static String get urlFavorites => '$server/userFavorites';
}
