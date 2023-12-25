import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/products_list.dart';
import 'package:shop/pages/favorites_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/shop_page.dart';
import 'package:shop/widgets/app_drawer.dart';

class HomeScreenArgs {
  final int? tabIndex;

  HomeScreenArgs({this.tabIndex});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeScreenArgs? args =
          ModalRoute.of(context)?.settings.arguments as HomeScreenArgs?;

      if (args != null && args.tabIndex != null) {
        setState(() => _currentIndex = args.tabIndex!);
      }

      setState(() {
        _isLoading = true;
      });

      final products = Provider.of<ProductsList>(context, listen: false);

      products
          .loadProducts()
          .then((value) => setState(() => _isLoading = false));
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = [
      ShopPage(isLoading: _isLoading),
      const FavoritesPage(),
      const OrdersPage(),
    ][_currentIndex];

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(
          ['Minha Loja', 'Favoritos', 'Meus Pedidos'][_currentIndex],
        ),
        backgroundColor: Colors.deepPurple.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          Visibility(
            visible: _currentIndex != 2,
            child: Consumer<Cart>(
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
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Minha Loja',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            activeIcon: Icon(Icons.payment),
            label: 'Meus Pedidos',
          ),
        ],
      ),
    );
  }
}
