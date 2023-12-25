import 'package:flutter/material.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: const Text('Bem vindo Usuário'),
          automaticallyImplyLeading: false,
        ),
        const SizedBox(height: 8.0),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text('Loja'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shelves),
          title: const Text('Produtos'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.products);
          },
        ),
      ],
    ));
  }
}
