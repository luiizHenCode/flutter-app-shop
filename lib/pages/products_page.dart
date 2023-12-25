import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/products_list.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/product_item_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool _visibleSearch = false;

  final TextEditingController _searchController = TextEditingController();

  Future<void> _loadProducts(BuildContext context) async {
    final provider = Provider.of<ProductsList>(context, listen: false);

    await provider.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsList>(context);

    List<Product> filteredProducts = provider.items.where(
      (product) {
        return product.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      },
    ).toList();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Colors.deepPurple.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _visibleSearch ? Icons.search_off_sharp : Icons.search,
            ),
            onPressed: () {
              setState(() {
                _visibleSearch = !_visibleSearch;
              });

              if (!_visibleSearch) {
                _searchController.clear();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: _visibleSearch,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                prefixIcon: Icon(Icons.search),
                filled: true,
                hintText: 'Pesquisar produto...',
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () => _loadProducts(context),
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 80,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      ProductItemCard(
                        key: ValueKey(filteredProducts[index].id),
                        product: filteredProducts[index],
                      ),
                      const Divider(thickness: 0, height: 0),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.withOpacity(0.95),
        tooltip: 'Adicionar Produto',
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.productForm);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
