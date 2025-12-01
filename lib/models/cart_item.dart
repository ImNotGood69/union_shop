class CartItem {
  final String id;
  final String productId;
  final String title;
  final String price;
  final String imageUrl;
  final String size;
  int quantity;
  final String? originalPrice;
  final String? description;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.size,
    required this.quantity,
    this.originalPrice,
    this.description,
  });

  double get priceValue {
    return double.tryParse(price.replaceAll('£', '')) ?? 0.0;
  }

  double get totalPrice {
    return priceValue * quantity;
  }
}
