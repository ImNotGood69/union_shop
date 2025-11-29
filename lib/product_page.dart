import 'package:flutter/material.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/data/products.dart';
import 'package:union_shop/search/product_search.dart';
import 'package:union_shop/widgets/about_button.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  void placeholderCallbackForButtons() {
    // event handler for buttons that don't do anything yet
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product?;

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

            // Product details
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product?.imageUrl ??
                            'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                        fit: BoxFit.cover,
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

                  const SizedBox(height: 24),

                  // Product name
                  Text(
                    product?.title ?? 'Placeholder Product Name',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),

                  const SizedBox(height: 12),

                  // Product price
                  Text(
                    product?.price ?? '£15.00',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4d2963)),
                  ),

                  const SizedBox(height: 24),

                  // Product description
                  const Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product == null
                        ? 'This is a placeholder description for the product. Replace with real product information.'
                        : '',
                    style: const TextStyle(
                        fontSize: 16, color: Colors.grey, height: 1.5),
                  ),
                ],
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      hours,
                      const SizedBox(height: 16),
                      contact,
                    ],
                  );
                }

                return Row(
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
