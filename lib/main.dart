import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/about/about_page.dart';
import 'package:union_shop/contact/contact_page.dart';
import 'package:union_shop/collections/collections_page.dart';
import 'package:union_shop/collections/collection_detail.dart';
import 'package:union_shop/widgets/header_bar.dart';
import 'package:union_shop/widgets/mobile_drawer.dart';
import 'package:union_shop/data/products.dart';
import 'package:union_shop/auth/sign_in_page.dart';
import 'package:union_shop/cart/cart_page.dart';
import 'package:union_shop/providers/cart_provider.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: MaterialApp(
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
          '/signin': (context) => const SignInPage(),
          '/cart': (context) => const CartPage(),
        },
      ),
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
  Timer? _carouselTimer;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final p = _pageController.page?.round() ?? 0;
      if (p != _page) setState(() => _page = p);
    });
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final current = _pageController.page?.round() ?? _page;
      final next = (current + 1) % 2;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<dynamic> _sortProducts(List<dynamic> products) {
    final sorted = List.from(products);

    if (_selectedFilter == 'Price: Low to High') {
      sorted.sort((a, b) {
        final priceA = double.tryParse(a.price.replaceAll('£', '')) ?? 0;
        final priceB = double.tryParse(b.price.replaceAll('£', '')) ?? 0;
        return priceA.compareTo(priceB);
      });
    } else if (_selectedFilter == 'Price: High to Low') {
      sorted.sort((a, b) {
        final priceA = double.tryParse(a.price.replaceAll('£', '')) ?? 0;
        final priceB = double.tryParse(b.price.replaceAll('£', '')) ?? 0;
        return priceB.compareTo(priceA);
      });
    } else if (_selectedFilter == 'A-Z') {
      sorted.sort((a, b) => a.title.compareTo(b.title));
    } else if (_selectedFilter == 'Z-A') {
      sorted.sort((a, b) => b.title.compareTo(a.title));
    }
    // 'All' keeps original order

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    const brandPurple = Color(0xFF4d2963);
    final sortedProducts = _sortProducts(products);

    return Scaffold(
      appBar: const HeaderBar(),
      drawer: const MobileDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                                image: AssetImage('assets/images/Banner_2.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                                color: Colors.black.withOpacity(0.55)),
                          ),
                        ),
                        const Positioned(
                            left: 24,
                            right: 24,
                            top: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Placeholder Hero Title',
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2)),
                                SizedBox(height: 16),
                                Text(
                                    'This is placeholder text for the hero section.',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        height: 1.5),
                                    textAlign: TextAlign.center),
                                SizedBox(height: 32),
                              ],
                            )),
                      ]),

                      // Slide 2: collections promo
                      Stack(children: [
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/Banner_1.png'),
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

                  // Left / Right arrow buttons
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (!_pageController.hasClients) return;
                            final current =
                                _pageController.page?.round() ?? _page;
                            final prev = (current - 1 + 2) % 2;
                            _pageController.animateToPage(prev,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          },
                          customBorder: const CircleBorder(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.arrow_back_ios,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (!_pageController.hasClients) return;
                            final current =
                                _pageController.page?.round() ?? _page;
                            final next = (current + 1) % 2;
                            _pageController.animateToPage(next,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          },
                          customBorder: const CircleBorder(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
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
                    const SizedBox(height: 24),
                    // Filter dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sort by:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          DropdownButton<String>(
                            value: _selectedFilter,
                            items: const [
                              DropdownMenuItem(
                                  value: 'All', child: Text('All')),
                              DropdownMenuItem(
                                  value: 'Price: Low to High',
                                  child: Text('Price: Low to High')),
                              DropdownMenuItem(
                                  value: 'Price: High to Low',
                                  child: Text('Price: High to Low')),
                              DropdownMenuItem(
                                  value: 'A-Z', child: Text('A-Z')),
                              DropdownMenuItem(
                                  value: 'Z-A', child: Text('Z-A')),
                            ],
                            onChanged: (v) {
                              setState(() => _selectedFilter = v ?? 'All');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: MediaQuery.of(context).size.width > 900
                          ? 3
                          : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 48,
                      children: sortedProducts
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

            // Footer
            Container(
              width: double.infinity,
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: LayoutBuilder(builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 600;
                const hours = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  children: [
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
    final decorated = Column(
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
        const SizedBox(height: 4),
        Text(title,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            maxLines: 2),
        const SizedBox(height: 4),
        Text(price, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: decorated);
    }
    return decorated;
  }
}
