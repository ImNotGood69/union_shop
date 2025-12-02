import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/widgets/header_bar.dart';
import 'package:union_shop/widgets/mobile_drawer.dart';
import 'package:union_shop/providers/cart_provider.dart';

class PersonalisePage extends StatefulWidget {
  const PersonalisePage({super.key});

  @override
  State<PersonalisePage> createState() => _PersonalisePageState();
}

class _PersonalisePageState extends State<PersonalisePage> {
  int _numberOfLines = 1;
  final List<TextEditingController> _textControllers = [
    TextEditingController(),
  ];

  double get _totalPrice {
    return _numberOfLines * 10.0;
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateControllers() {
    while (_textControllers.length < _numberOfLines) {
      _textControllers.add(TextEditingController());
    }
    while (_textControllers.length > _numberOfLines) {
      _textControllers.removeLast().dispose();
    }
  }

  void _addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final textLines = _textControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (textLines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one line of text'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final customization = textLines.join(' | ');

    cartProvider.addItem(
      productId: 'custom-hoodie-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Personalised Hoodie',
      price: '£${_totalPrice.toStringAsFixed(2)}',
      imageUrl:
          'https://shop.upsu.net/cdn/shop/files/GreyHoodieFinal_1024x1024@2x.jpg?v=1742201957',
      size: 'Custom',
      description: 'Text: $customization',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Clear the text fields
    for (var controller in _textControllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(),
      drawer: const MobileDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personalise Your Clothes',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;

                  final imageWidget = Container(
                    width: isWide ? 400 : double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://shop.upsu.net/cdn/shop/files/GreyHoodieFinal_1024x1024@2x.jpg?v=1742201957',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 8),
                                Text(
                                  'Placeholder Image',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );

                  final controlsWidget = Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Number of Text Lines',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _numberOfLines,
                                isExpanded: true,
                                items: List.generate(
                                  3,
                                  (index) => DropdownMenuItem(
                                    value: index + 1,
                                    child: Text(
                                        '${index + 1} line${index + 1 > 1 ? 's' : ''}'),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _numberOfLines = value ?? 1;
                                    _updateControllers();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...List.generate(
                          _numberOfLines,
                          (index) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: 12.0, right: 16.0),
                            child: TextField(
                              controller: _textControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Line ${index + 1}',
                                border: const OutlineInputBorder(),
                                hintText: 'Enter text for line ${index + 1}',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Price:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '£${_totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4d2963),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4d2963),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageWidget,
                        const SizedBox(width: 32),
                        Expanded(child: controlsWidget),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      imageWidget,
                      const SizedBox(height: 24),
                      controlsWidget,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
