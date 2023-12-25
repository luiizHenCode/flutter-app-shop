class CartItem {
  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  String get priceFormatted {
    return '$quantity x R\$ ${price.toStringAsFixed(2)}';
  }

  String get totalFormatted {
    return 'R\$ ${(price * quantity).toStringAsFixed(2)}';
  }
}
