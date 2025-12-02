import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/providers/cart_provider.dart';

class AboutPrintShackPage extends StatelessWidget {
  const AboutPrintShackPage({super.key});

  static const Color _brandPurple = Color(0xFF4d2963);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About The Print Shack',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _brandPurple,
        actions: [
          Consumer<CartProvider>(
            builder: (ctx, cart, child) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined,
                      color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                ),
                if (cart.totalQuantity > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 16, minHeight: 16),
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
      backgroundColor: Colors.white,
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'The Print Shack',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your personalisation destination!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 149, 144, 151),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'The Print Shack offers exclusive personalisation services for all your University merchandise. Whether you want to add your name to your hoodie, customise your t-shirt, or create a unique gift, we can help bring your ideas to life!',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 149, 144, 151)),
              ),
              SizedBox(height: 12),
              Text(
                'Our state-of-the-art printing equipment ensures high-quality results every time. Choose from a variety of fonts, colours, and designs to make your merchandise truly yours.',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 149, 144, 151)),
              ),
              SizedBox(height: 12),
              Text(
                'Visit us in-store or use our online personalisation tool to get started. All personalised items are available for collection within 5-7 working days.',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 149, 144, 151)),
              ),
              SizedBox(height: 20),
              Text(
                'For more information, contact us at printshack@upsu.net',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 149, 144, 151),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
