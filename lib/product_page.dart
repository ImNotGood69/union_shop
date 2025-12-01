// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/data/products.dart';
import 'package:union_shop/search/product_search.dart';
import 'package:union_shop/widgets/about_button.dart';
import 'package:flutter/services.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String _selectedSize = 'M';
  int _quantity = 1;
  late TextEditingController _qtyController;

  void _setSize(String s) => setState(() => _selectedSize = s);
  // quantity is set directly via setState in handlers; helper removed

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: '$_quantity');
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  void placeholderCallbackForButtons() {}

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    // Handle both Product objects and Map data from collections
    String? productTitle;
    String? productPrice;
    String? productImageUrl;
    String? originalPrice;
    String? productDescription;

    if (args is Product) {
      productTitle = args.title;
      productPrice = args.price;
      productImageUrl = args.imageUrl;
    } else if (args is Map<String, dynamic>) {
      productTitle = args['title'] as String?;
      productPrice = args['price'] as String?;
      productImageUrl = args['imageUrl'] as String?;
      originalPrice = args['originalPrice'] as String?;
      productDescription = args['description'] as String?;
    }

    const brandPurple = Color(0xFF4d2963);

    final sizes = ['S', 'M', 'L', 'XL'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header (unchanged)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  // logo / home
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

            // Product details area - responsive two-column on wide screens
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;

                final rightControls = ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Size selector
                      const Text('Size',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: sizes
                            .map((s) => ChoiceChip(
                                  label: Text(s),
                                  selected: _selectedSize == s,
                                  onSelected: (_) => _setSize(s),
                                  selectedColor: brandPurple,
                                  backgroundColor: Colors.grey[200],
                                  labelStyle: TextStyle(
                                      color: _selectedSize == s
                                          ? Colors.white
                                          : Colors.black),
                                ))
                            .toList(),
                      ),

                      const SizedBox(height: 24),

                      // Quantity input with dropdown (both synced)
                      const Text('Quantity',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Free-form numeric input
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey[50],
                              ),
                              child: TextField(
                                controller: _qtyController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                                onChanged: (s) {
                                  final v = int.tryParse(s);
                                  setState(() {
                                    _quantity = v ?? 0;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Dropdown list still available
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: (_quantity >= 1 && _quantity <= 10)
                                    ? _quantity
                                    : null,
                                hint: const Text('1-10'),
                                items: List.generate(
                                    10,
                                    (i) => DropdownMenuItem(
                                          value: i + 1,
                                          child: Text('${i + 1}'),
                                        )),
                                onChanged: (v) {
                                  if (v == null) return;
                                  setState(() {
                                    _quantity = v;
                                    _qtyController.text = '$_quantity';
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Purchase button (non functional)
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Add to cart',
                            style: TextStyle(fontSize: 16)),
                      ),

                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: brandPurple,
                          side:
                              BorderSide(color: brandPurple.withOpacity(0.15)),
                        ),
                        child: const Text('Buy now'),
                      ),
                    ],
                  ),
                );

                final imageCard = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 6)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          productImageUrl ??
                              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_not_supported,
                                        size: 64, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text('Image unavailable',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Name / Price / Description
                    Text(
                      productTitle ?? 'Placeholder Product Name',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          productPrice ?? '£15.00',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4d2963)),
                        ),
                        if (originalPrice != null &&
                            originalPrice != productPrice) ...[
                          const SizedBox(width: 12),
                          Text(
                            originalPrice,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Description',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      productDescription ??
                          'This is a placeholder description for the product. Replace with real product information.',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.grey, height: 1.5),
                    ),
                  ],
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image on the left (smaller)
                      Flexible(flex: 1, child: imageCard),
                      const SizedBox(width: 24),
                      // Controls on the right (larger)
                      Flexible(flex: 4, child: rightControls),
                    ],
                  );
                }

                // Narrow layout: stack image then controls
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageCard,
                    const SizedBox(height: 20),
                    rightControls,
                  ],
                );
              }),
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
