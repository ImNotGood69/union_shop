import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/search/product_search.dart';
import 'package:union_shop/data/catalog.dart';
import 'package:union_shop/widgets/about_button.dart';
import 'package:union_shop/providers/cart_provider.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderBar({super.key});

  static const brandPurple = Color(0xFF4d2963);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 768;

    return Material(
      color: Colors.white,
      elevation: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              child: Image.network(
                'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  );
                },
              ),
            ),
            const Spacer(),
            if (isNarrow)
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, size: 24, color: Colors.grey),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search,
                          size: 20, color: Colors.grey),
                      onPressed: () async {
                        final selected = await showSearch(
                            context: context,
                            delegate: ProductSearchDelegate(allProducts));
                        if (selected != null && context.mounted) {
                          Navigator.pushNamed(context, '/product',
                              arguments: selected);
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signin'),
                      child: const Text('Sign In',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    const AboutButton(),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/collections'),
                      child: const Text('Collections',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    PopupMenuButton<String>(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('The Print Shack',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_drop_down,
                                color: Colors.grey, size: 20),
                          ],
                        ),
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'about',
                          child: Text('About Print Shack'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'personalise',
                          child: Text('Personalise Clothes'),
                        ),
                      ],
                      onSelected: (String value) {
                        if (value == 'about') {
                          Navigator.pushNamed(context, '/print-shack/about');
                        } else if (value == 'personalise') {
                          Navigator.pushNamed(
                              context, '/print-shack/personalise');
                        }
                      },
                    ),
                    Consumer<CartProvider>(
                      builder: (ctx, cart, child) => Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined,
                                size: 20, color: Colors.grey),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/cart'),
                          ),
                          if (cart.totalQuantity > 0)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: brandPurple,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${cart.totalQuantity}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
