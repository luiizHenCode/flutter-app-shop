import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/products_list.dart';

class ProductDeailPage extends StatefulWidget {
  const ProductDeailPage({super.key});

  @override
  State<ProductDeailPage> createState() => _ProductDeailPageState();
}

class _ProductDeailPageState extends State<ProductDeailPage> {
  final ScrollController _scrollController = ScrollController();

  double _appBarTitleOpacity = 0.0;

  void _scrollListener() {
    if (_scrollController.offset >= 300) {
      setState(() {
        _appBarTitleOpacity = 1.0;
      });
    } else {
      setState(() {
        _appBarTitleOpacity = 0.0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final messager = ScaffoldMessenger.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 400,
                  pinned: true,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    opacity: _appBarTitleOpacity,
                    child: Text(product.name),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: product.id,
                      transitionOnUserGestures: true,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.darken,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.black.withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: const Alignment(0, 0.1),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
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
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
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
                )
              ],
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
