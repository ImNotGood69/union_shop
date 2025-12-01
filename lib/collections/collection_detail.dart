import 'package:flutter/material.dart';
import 'package:union_shop/widgets/header_bar.dart';
import 'package:union_shop/widgets/mobile_drawer.dart';

class CollectionDetailPage extends StatefulWidget {
  const CollectionDetailPage({super.key});

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  String _selectedFilter = 'All';

  List<Map<String, String>> _sortProducts(List<Map<String, String>> products) {
    final sorted = List<Map<String, String>>.from(products);

    if (_selectedFilter == 'Price: Low to High') {
      sorted.sort((a, b) {
        final priceA =
            double.tryParse(a['price']?.replaceAll('£', '') ?? '0') ?? 0;
        final priceB =
            double.tryParse(b['price']?.replaceAll('£', '') ?? '0') ?? 0;
        return priceA.compareTo(priceB);
      });
    } else if (_selectedFilter == 'Price: High to Low') {
      sorted.sort((a, b) {
        final priceA =
            double.tryParse(a['price']?.replaceAll('£', '') ?? '0') ?? 0;
        final priceB =
            double.tryParse(b['price']?.replaceAll('£', '') ?? '0') ?? 0;
        return priceB.compareTo(priceA);
      });
    }
    // 'All' and 'Newest' keep original order

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    String title = args?['title'] ?? 'Collection';
    if (title == 'Black Friday') {
      // rename legacy route titles to the new label
      title = 'On sale!';
    }
    final image =
        args?['image'] ?? 'https://via.placeholder.com/800x400?text=Collection';

    // placeholder product list for this collection
    late final List<Map<String, String>> baseProducts;

    if (title == 'Black Friday' || title == 'On sale!') {
      // populate On sale! with the requested product names and both
      // discounted and original prices (original shown struck-through)
      baseProducts = [
        {
          'title': 'Portsmouth University 2025 Hoodie',
          'price': '£25.00', // discounted
          'originalPrice': '£45.00',
          'image':
              'https://shop.upsu.net/cdn/shop/products/GradGrey_5184x.jpg?v=1657288025',
          'description':
              'Stay warm and show your Portsmouth University pride with this comfortable 2025 hoodie. Made from premium materials for ultimate comfort.'
        },
        {
          'title': 'Neutral Classic Sweatshirt',
          'price': '£20.00',
          'originalPrice': '£35.00',
          'image':
              'https://shop.upsu.net/cdn/shop/files/Neutral_-_Sept_24_300x300.png?v=1750063651',
          'description':
              'A versatile classic sweatshirt in neutral tones, perfect for everyday wear on campus or casual outings.'
        },
        // remaining placeholders
        {
          'title': 'red and purple hoodie',
          'price': '£15.00',
          'originalPrice': '£25.00',
          'image':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFdw2yoLVCbLmGbxOh31qTAk-OGEQRXr4LUQ&s',
          'description':
              'Bold red and purple hoodie featuring university colors. A stylish way to represent your school spirit.'
        },
        {
          'title': 'UP logo lanyard',
          'price': '£1.50',
          'originalPrice': '£4.00',
          'image':
              'https://shop.upsu.net/cdn/shop/products/IMG_0645_345x345@2x.jpg?v=1557218961',
          'description':
              'Practical lanyard with the official UP logo, ideal for holding your student ID, keys, or access cards.'
        },
        {
          'title': 'Uni colours hoodie',
          'price': '£12.00',
          'originalPrice': '£20.00',
          'image':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW34pjvxrriWxTK8JMQWMBLUAPQPkxGgoJoZImOoVydOmNqWnhtujYteaYrqLWRQXJRLc&usqp=CAU',
          'description':
              'Cozy hoodie showcasing the official university colors. Perfect for chilly days on campus or relaxing at home.'
        },
        {
          'title': 'Campus mug',
          'price': '£5.00',
          'originalPrice': '£9.00',
          'image':
              'https://images-eu.ssl-images-amazon.com/images/I/71g2qnv0TCL._AC_UL495_SR435,495_.jpg',
          'description':
              'Start your day with this ceramic campus mug featuring the university branding. Great for coffee, tea, or hot chocolate.'
        },
      ];
    } else {
      baseProducts = List.generate(
          6,
          (i) => {
                'title': 'Placeholder Product ${i + 1}',
                'price': '£${(10 + i * 5).toStringAsFixed(2)}',
                'originalPrice': '£${(10 + i * 5).toStringAsFixed(2)}',
                'image':
                    'https://via.placeholder.com/400x300?text=Product+${i + 1}'
              });
    }

    // Apply sorting
    final products = _sortProducts(baseProducts);

    return Scaffold(
      appBar: const HeaderBar(),
      drawer: const MobileDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // collection image
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey[300]),
              ),
            ),

            // title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // promotional message for On sale!
            if (title == 'Black Friday' || title == 'On sale!')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4d2963),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'On Sale! Limited-time deals across campus merch — up to 50% off selected items. Grab your favourites while stocks last!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // filter dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sort by:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(
                          value: 'Price: Low to High',
                          child: Text('Price: Low to High')),
                      DropdownMenuItem(
                          value: 'Price: High to Low',
                          child: Text('Price: High to Low')),
                      DropdownMenuItem(value: 'Newest', child: Text('Newest')),
                    ],
                    onChanged: (v) {
                      setState(() => _selectedFilter = v ?? 'All');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // products grid - scroll-friendly, no tile overflow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width > 1000
                    ? 4
                    : (MediaQuery.of(context).size.width > 800
                        ? 3
                        : (MediaQuery.of(context).size.width > 600 ? 2 : 1)),
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                // slightly taller cells to accommodate price lines
                childAspectRatio: 0.75,
                children: products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final p = entry.value;
                  final isDiscounted =
                      (p['originalPrice'] ?? '') != (p['price'] ?? '');
                  return InkWell(
                    onTap: () {
                      // Create a product object to pass to ProductPage
                      final productData = {
                        'id': 'sale_${index + 1}',
                        'title': p['title']!,
                        'price': p['price']!,
                        'imageUrl': p['image']!,
                        'originalPrice': p['originalPrice'],
                        'description': p['description'],
                      };
                      Navigator.pushNamed(
                        context,
                        '/product',
                        arguments: productData,
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              p['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Text(
                              p['title']!,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  p['price'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isDiscounted
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isDiscounted
                                        ? const Color(0xFF4d2963)
                                        : Colors.grey[800],
                                  ),
                                ),
                                if (isDiscounted) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    p['originalPrice'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
