import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/orders_list.dart';
import 'package:shop/models/products_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_page.dart';
import 'package:shop/theme/custom_page_transition.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsList>(
          create: (_) => ProductsList(),
          update: (ctx, auth, previousProducts) => ProductsList(
            auth.token ?? '',
            auth.userId ?? '',
            previousProducts?.items ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, OrdersList>(
          create: (_) => OrdersList(),
          update: (ctx, auth, previousOrders) => OrdersList(
            auth.token ?? '',
            previousOrders?.items ?? [],
            auth.userId ?? '',
          ),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Lato',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransition(),
              TargetPlatform.iOS: CustomPageTransition(),
            },
          )),
      routes: {
        AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
        AppRoutes.productDetail: (ctx) => const ProductDeailPage(),
        AppRoutes.cart: (ctx) => const CartPage(),
        AppRoutes.products: (ctx) => const ProductsPage(),
        AppRoutes.productForm: (ctx) => const ProductFormPage(),
      },
    );
  }
}
