import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showOnlyFavorites;

  ProductsGrid(this._showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    final loadedProducts = _showOnlyFavorites ? products.favoriteitems : products.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: ProductItem(
            // loadedProducts[index].id,
            // loadedProducts[index].title,
            // loadedProducts[index].imageUrl,
            ),
      ),
    );
  }
}
