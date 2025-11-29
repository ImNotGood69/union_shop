import 'package:flutter/material.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/about/about_page.dart';
import 'package:union_shop/contact/contact_page.dart';
import 'package:union_shop/collections/collections_page.dart';
import 'package:union_shop/collections/collection_detail.dart';
import 'package:union_shop/widgets/about_button.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/data/products.dart';
import 'package:union_shop/search/product_search.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/product': (context) => const ProductPage(),
        '/about': (context) => const AboutPage(),
        '/contact': (context) => const ContactPage(),
        '/collections': (context) => const CollectionsPage(),
        '/collections/detail': (context) => const CollectionDetailPage(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  void placeholderCallbackForButtons() {}

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final p = _pageController.page?.round() ?? 0;
      if (p != _page) setState(() => _page = p);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brandPurple = Color(0xFF4d2963);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/', (r) => false),
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
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search,
                              size: 20, color: Colors.grey),
                          onPressed: () async {
                            final Product? selected =
                                await showSearch<Product?>(
                              context: context,
                              delegate: ProductSearchDelegate(products),
                            );
                            if (selected != null) {
                              Navigator.pushNamed(context, '/product',
                                  arguments: selected);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.person_outline,
                              size: 20, color: Colors.grey),
                          onPressed: placeholderCallbackForButtons,
                        ),
                        const AboutButton(),
                        IconButton(
                          icon: const Icon(Icons.shopping_bag_outlined,
                              size: 20, color: Colors.grey),
                          onPressed: placeholderCallbackForButtons,
                        ),
                        IconButton(
                          icon: const Icon(Icons.menu,
                              size: 20, color: Colors.grey),
                          onPressed: placeholderCallbackForButtons,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Carousel Hero Section
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    children: [
                      // Slide 1
                      Stack(children: [
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                                color: Colors.black.withOpacity(0.55)),
                          ),
                        ),
                        Positioned(
                            left: 24,
                            right: 24,
                            top: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Placeholder Hero Title',
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2)),
                                const SizedBox(height: 16),
                                const Text(
                                    "This is placeholder text for the hero section.",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        height: 1.5),
                                    textAlign: TextAlign.center),
                                const SizedBox(height: 32),
                                ElevatedButton(
                                  onPressed: placeholderCallbackForButtons,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: brandPurple,
                                      foregroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero)),
                                  child: const Text('BROWSE PRODUCTS',
                                      style: TextStyle(
                                          fontSize: 14, letterSpacing: 1)),
                                ),
                              ],
                            )),
                      ]),

                      // Slide 2: collections promo
                      Stack(children: [
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                                color: Colors.black.withOpacity(0.45)),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/collections'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: brandPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14)),
                            child: const Text('VIEW COLLECTIONS',
                                style:
                                    TextStyle(fontSize: 16, letterSpacing: 1)),
                          ),
                        ),
                      ]),
                    ],
                  ),

                  // Dots indicator
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          2,
                          (i) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: _page == i ? 12 : 8,
                                height: _page == i ? 12 : 8,
                                decoration: BoxDecoration(
                                    color: _page == i
                                        ? brandPurple
                                        : Colors.white70,
                                    shape: BoxShape.circle),
                              )),
                    ),
                  ),
                ],
              ),
            ),

            // Products Section
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text(
                      'PRODUCTS SECTION',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 48),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: MediaQuery.of(context).size.width > 900
                          ? 3
                          : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 48,
                      children: products
                          .map((p) => GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/product',
                                    arguments: p),
                                child: ProductCard(
                                  title: p.title,
                                  price: p.price,
                                  imageUrl: p.imageUrl,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Footer (Opening hours + Contact details)
            Container(
              width: double.infinity,
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: LayoutBuilder(builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 600;
                const hours = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Opening Hours',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    Text('Monday: 09:00 - 17:00'),
                    Text('Tuesday: 09:00 - 17:00'),
                    Text('Wednesday: 09:00 - 17:00'),
                    Text('Thursday: 09:00 - 17:00'),
                    Text('Friday: 09:00 - 17:00'),
                  ],
                );

                const contact = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Contact Us',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    Text('Email: fakeemail@email.com'),
                    Text('Phone: 076942099019'),
                  ],
                );

                if (isNarrow) {
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      hours,
                      SizedBox(height: 16),
                      contact,
                    ],
                  );
                }

                return const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hours,
                    contact,
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
