import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/products_list.dart';
import 'package:shop/widgets/products_grid.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsList>(context, listen: true);
    final List<Product> loadedProducts = provider.favoriteItems;

    return Visibility(
      visible: loadedProducts.isNotEmpty,
      replacement: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80.0,
              color: Colors.grey,
            ),
            Text(
              'Nenhum produto favorito',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      child: ProductsGrid(
        products: loadedProducts,
      ),
    );
  }
}
