import 'package:flutter/foundation.dart';
import 'package:union_shop/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  int get totalQuantity {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addItem({
    required String productId,
    required String title,
    required String price,
    required String imageUrl,
    required String size,
    String? originalPrice,
    String? description,
  }) {
    final key = '$productId-$size';

    if (_items.containsKey(key)) {
      // Update quantity if item with same product and size exists
      _items[key]!.quantity += 1;
    } else {
      // Add new item
      _items[key] = CartItem(
        id: DateTime.now().toString(),
        productId: productId,
        title: title,
        price: price,
        imageUrl: imageUrl,
        size: size,
        quantity: 1,
        originalPrice: originalPrice,
        description: description,
      );
    }
    notifyListeners();
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void updateQuantity(String key, int quantity) {
    if (_items.containsKey(key)) {
      if (quantity <= 0) {
        _items.remove(key);
      } else {
        _items[key]!.quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
