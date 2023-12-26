import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
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
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.authOrHome);
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
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () {
                showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog.adaptive(
                        title: const Text('Sair'),
                        content: const Text('Tem certeza?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Não'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Sim'),
                          ),
                        ],
                      );
                    }).then((value) {
                  if (value) {
                    auth.logout();

                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.authOrHome,
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
