import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  double _opacity = 0.0;

  Future<bool> _confirmRemoveItem() async {
    bool? shouldDismiss = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Deseja remover o item do carrinho?'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirmar'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancelar'),
          ),
        );
      },
    );

    return shouldDismiss ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);

    return Dismissible(
      key: ValueKey(widget.cartItem.id),
      onDismissed: (_) {
        cart.removeItem(widget.cartItem.productId);
      },
      behavior: HitTestBehavior.translucent,
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _confirmRemoveItem();
      },
      dismissThresholds: const {
        DismissDirection.endToStart: 0.6,
      },
      onUpdate: (details) {
        double opacity = details.progress + 0.2;

        if (opacity <= 1) {
          setState(() {
            _opacity = opacity;
          });
        } else {
          setState(() {
            _opacity = 1;
          });
        }
      },
      background: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 32),
          child: Opacity(
            opacity: _opacity,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          color: Colors.grey[100],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                width: 100,
                height: 100,
                child: Image(
                  image: NetworkImage(widget.cartItem.imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cartItem.name,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.cartItem.priceFormatted,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.cartItem.totalFormatted,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Consumer<Cart>(builder: (ctx, cart, _) {
                return Column(
                  children: [
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple.withOpacity(0.8)),
                      ),
                      onPressed: () {
                        cart.incrementQtd(widget.cartItem.productId);
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        cart.decrementQtd(widget.cartItem.productId);
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
