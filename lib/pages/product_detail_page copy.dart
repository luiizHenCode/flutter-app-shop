import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/products_list.dart';

class ProductDeailPage extends StatelessWidget {
  const ProductDeailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final messager = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          Consumer<ProductsList>(builder: (ctx, provider, _) {
            return IconButton(
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
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: product.isFavorite ? Colors.red : Colors.white,
              ),
            );
          }),
          Consumer<Cart>(
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
            ),
            builder: (ctx, cart, child) => Badge.count(
              count: cart.itemsCount,
              isLabelVisible: cart.itemsCount > 0,
              offset: const Offset(-10, 5),
              child: child!,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: Hero(
                      tag: product.id,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.description,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<Cart>(
            child: Container(
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              width: double.infinity,
              height: 60 + MediaQuery.of(context).padding.bottom,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
                top: MediaQuery.of(context).padding.bottom * 0.5,
              ),
              alignment: Alignment.center,
              child: Text(
                'Adicionar ao carrinho'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            builder: (ctx, cart, child) {
              return InkWell(
                onTap: () => cart.addItem(product),
                splashColor: Colors.deepPurple,
                child: child,
              );
            },
          )
        ],
      ),
    );
  }
}
