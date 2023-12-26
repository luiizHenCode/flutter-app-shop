import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/orders_list.dart';
import 'package:shop/widgets/order_item_card.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () {
        return Provider.of<OrdersList>(context, listen: false).loadOrders();
      },
      child: FutureBuilder(
          future: Provider.of<OrdersList>(context, listen: false).loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.error != null) {
              return const Center(child: Text('Ocorreu um erro!'));
            }

            return Consumer<OrdersList>(builder: (context, orders, child) {
              return Visibility(
                visible: orders.itemsCount > 0,
                replacement: const Center(
                  child: Text('Nenhum pedido encontrado!'),
                ),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: orders.items.length,
                  padding: const EdgeInsets.all(8.0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (ctx, index) {
                    return OrderItemCard(order: orders.items[index]);
                  },
                ),
              );
            });
          }),
    );
  }
}
