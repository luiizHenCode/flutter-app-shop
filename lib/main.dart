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
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsList()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => OrdersList()),
        ChangeNotifierProvider(create: (_) => Auth()),
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
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
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
