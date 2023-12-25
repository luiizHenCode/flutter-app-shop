import 'package:intl/intl.dart';
import 'package:shop/models/cart_item.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });

  int get productsCount => products.length;

  String get formattedTotal {
    return NumberFormat.currency(
      symbol: 'R\$ ',
      decimalDigits: 2,
      locale: 'pt_BR',
    ).format(total);
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  String get productsCountString {
    return '$productsCount ${productsCount == 1 ? 'item' : 'itens'}';
  }
}
