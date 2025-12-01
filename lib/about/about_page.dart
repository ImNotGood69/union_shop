import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/providers/cart_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color _brandPurple = Color(0xFF4d2963);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
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
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white, // page background is white again
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color:
                      Color.fromARGB(255, 0, 0, 0), // only this title is black
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to the Union Shop!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 149, 144,
                      151), // other text uses brand purple (not black)
                ),
              ),
              SizedBox(height: 12),
              Text(
                "We're dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive personalisation service!",
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 149, 144, 151)),
              ),
              SizedBox(height: 12),
              Text(
                'All online purchases are available for delivery or instore collection!',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 149, 144, 151)),
              ),
              SizedBox(height: 12),
              Text(
                'We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don\'t hesitate to contact us at hello@upsu.net.',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 149, 144, 151)),
              ),
              SizedBox(height: 12),
              Text(
                'Happy shopping!',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 149, 144, 151)),
              ),
              SizedBox(height: 20),
              Text(
                'The Union Shop & Reception Team',
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
