import 'package:union_shop/models/product.dart';
import 'package:union_shop/data/products.dart' as base;
import 'package:union_shop/data/on_sale_products.dart' as sale;

/// Combined, de-duplicated catalog of all products available for search.
final List<Product> allProducts = _combineAndDedup([
  ...base.products,
  ...sale.onSaleProducts,
]);

List<Product> _combineAndDedup(List<Product> items) {
  final map = <String, Product>{};
  for (final p in items) {
    map[p.id] = p; // last write wins (sale items can override duplicates)
  }
  return map.values.toList(growable: false);
}
