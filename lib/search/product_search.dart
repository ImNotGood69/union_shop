import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/data/on_sale_products.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  String get searchFieldLabel => 'Search products';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final q = query.trim().toLowerCase();
    final isSaleQuery = q.contains('sale');
    final base = isSaleQuery ? onSaleProducts : products;
    final tokens = q
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty && t != 'sale')
        .toList();

    bool matchesPredicate(Product p) {
      if (tokens.isEmpty) return true; // when query is exactly 'sale'
      final title = p.title.toLowerCase();
      return tokens.every((t) => title.contains(t));
    }

    final results = base.where(matchesPredicate).toList();
    if (results.isEmpty) return const Center(child: Text('No results'));

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final p = results[index];
        return ListTile(
          leading: Image.network(p.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported)),
          title: Text(p.title),
          subtitle: Text(p.price),
          onTap: () => close(context, p),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final q = query.trim().toLowerCase();
    final isSaleQuery = q.contains('sale');
    final base = isSaleQuery ? onSaleProducts : products;
    final tokens = q
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty && t != 'sale')
        .toList();

    bool matchesPredicate(Product p) {
      if (tokens.isEmpty) return true;
      final title = p.title.toLowerCase();
      return tokens.every((t) => title.contains(t));
    }

    final suggestions = query.isEmpty
        ? base.take(5).toList()
        : base.where(matchesPredicate).toList();

    if (suggestions.isEmpty) {
      return const Center(child: Text('No matching products'));
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final p = suggestions[index];
        return ListTile(
          leading: Image.network(p.imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported)),
          title: Text(p.title),
          subtitle: Text(p.price),
          onTap: () => close(context, p),
        );
      },
    );
  }
}
