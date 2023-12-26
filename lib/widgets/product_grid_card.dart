import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/products_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: true);
    final messager = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.deepPurple.withOpacity(0.85),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<ProductsList>(builder: (ctx, provider, _) {
            return IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: product.isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () async {
                try {
                  await provider.toggleFavorite(product);
                } catch (error) {
                  messager.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Não foi possível atualizar o status do produto.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          }),
          trailing: Consumer<Cart>(
            builder: (ctx, cart, _) => Badge.count(
              count: cart.countByItem(product.id),
              isLabelVisible: cart.countByItem(product.id) > 0,
              offset: const Offset(-10, 5),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Produto ${product.name} adicionado ao carrinho!',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'DESFAZER',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.productDetail,
                arguments: product,
              );
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: const AssetImage(
                  'assets/images/placeholder-image.webp',
                ),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            )
            // child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
      ),
    );
  }
}
