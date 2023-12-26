import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/products_list.dart';
import 'package:shop/widgets/products_grid.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  Future<void> _loadProducts(BuildContext context) async {
    final provider = Provider.of<ProductsList>(context, listen: false);
    await provider.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsList>(context);
    final List<Product> loadedProducts = provider.items;

    return Visibility(
      visible: !isLoading,
      replacement: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      child: RefreshIndicator.adaptive(
        onRefresh: () async => await _loadProducts(context),
        child: ProductsGrid(
          products: loadedProducts,
        ),
      ),
    );
  }
}
