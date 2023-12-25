import 'package:flutter/material.dart';
import 'package:shop/models/order.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({
    super.key,
    required this.order,
  });

  final Order order;

  void _onShowInfo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        showDragHandle: true,
        barrierLabel: 'Order Details',
        backgroundColor: Colors.white,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.credit_card_outlined),
                ),
                title: Text(
                  order.formattedTotal,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(order.formattedDate),
              ),
              const Divider(height: 0, thickness: 0),
              Expanded(
                child: ListView.builder(
                  itemCount: order.products.length,
                  itemBuilder: (_, index) {
                    final item = order.products[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          item.imageUrl,
                        ),
                      ),
                      title: Text(item.name),
                      subtitle: Row(
                        children: [
                          Text(item.priceFormatted),
                          const Spacer(),
                          Text(item.totalFormatted),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _onShowInfo(context);
      },
      leading: const CircleAvatar(
        child: Icon(Icons.credit_card_outlined),
      ),
      tileColor: Colors.grey[100],
      title: Row(
        children: [
          Text(
            order.formattedTotal,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            order.productsCountString,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
      subtitle: Text(order.formattedDate),
    );
  }
}
