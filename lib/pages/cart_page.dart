import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/orders_list.dart';
import 'package:shop/pages/home_page.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/cart_item_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Carrinho de compras'),
      ),
      body: items.isEmpty
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Seu carrinho está vazio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                        width: double.infinity,
                        height: 48.0,
                        color: Colors.grey[100],
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total de itens: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              cart.itemsCount.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    itemCount: cart.uniqueItensCart,
                    separatorBuilder: (ctx, index) => const SizedBox(height: 8),
                    itemBuilder: (ctx, index) {
                      return CartItemCard(
                        key: ValueKey(items[index].id),
                        cartItem: items[index],
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 60.0,
                  color: Colors.deepPurple.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        cart.totalAmountString,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<OrdersList>(builder: (ctx, provider, child) {
                  return GestureDetector(
                    onTap: () {
                      provider.addOrder(cart);
                      cart.clear();

                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.authOrHome,
                        (route) => false,
                        arguments: HomeScreenArgs(
                          tabIndex: 2,
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.deepPurpleAccent,
                      width: double.infinity,
                      height: 60 + MediaQuery.of(context).padding.bottom,
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                        top: MediaQuery.of(context).padding.bottom * 0.5,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Finalizar compra'.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
