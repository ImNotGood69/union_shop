import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/search/product_search.dart';
import 'package:union_shop/data/products.dart';
import 'package:union_shop/providers/cart_provider.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  static const brandPurple = Color(0xFF4d2963);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Logo
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (r) => false);
                  },
                  child: Image.network(
                    'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        width: 50,
                        height: 50,
                        child: const Icon(Icons.image_not_supported,
                            color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              const Divider(),
              // Menu Items
              ListTile(
                leading: const Icon(Icons.search, color: Colors.grey),
                title: const Text('Search'),
                onTap: () async {
                  Navigator.pop(context);
                  final selected = await showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(products));
                  if (selected != null && context.mounted) {
                    Navigator.pushNamed(context, '/product',
                        arguments: selected);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.grey),
                title: const Text('Sign In'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/signin');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.grey),
                title: const Text('About Us'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.collections_outlined, color: Colors.grey),
                title: const Text('Collections'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/collections');
                },
              ),
              ExpansionTile(
                leading: const Icon(Icons.print, color: Colors.grey),
                title: const Text('The Print Shack'),
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 72),
                    title: const Text('About Print Shack'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/print-shack/about');
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 72),
                    title: const Text('Personalise Clothes'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/print-shack/personalise');
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined, color: Colors.grey),
                title: const Text('Contact'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/contact');
                },
              ),
              Consumer<CartProvider>(
                builder: (ctx, cart, child) => ListTile(
                  leading: Stack(
                    children: [
                      const Icon(Icons.shopping_bag_outlined,
                          color: Colors.grey),
                      if (cart.totalQuantity > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: brandPurple,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              '${cart.totalQuantity}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: const Text('Shopping Bag'),
                  trailing: cart.totalQuantity > 0
                      ? Text(
                          '${cart.totalQuantity} items',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
