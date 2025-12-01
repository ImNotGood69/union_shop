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
    late final List<Map<String, String>> products;

    if (title == 'Black Friday' || title == 'On sale!') {
      // populate On sale! with the requested product names and both
      // discounted and original prices (original shown struck-through)
      products = [
        {
          'title': 'Portsmouth University 2025 Hoodie',
          'price': '£25.00', // discounted
          'originalPrice': '£45.00',
          'image': 'https://via.placeholder.com/400x300?text=Hoodie'
        },
        {
          'title': 'Neutral Classic Sweatshirt',
          'price': '£20.00',
          'originalPrice': '£35.00',
          'image': 'https://via.placeholder.com/400x300?text=Sweatshirt'
        },
        // remaining placeholders
        {
          'title': 'Placeholder Product 3',
          'price': '£15.00',
          'originalPrice': '£25.00',
          'image': 'https://via.placeholder.com/400x300?text=Product+3'
        },
        {
          'title': 'Placeholder Product 4',
          'price': '£18.00',
          'originalPrice': '£30.00',
          'image': 'https://via.placeholder.com/400x300?text=Product+4'
        },
        {
          'title': 'Placeholder Product 5',
          'price': '£12.00',
          'originalPrice': '£20.00',
          'image': 'https://via.placeholder.com/400x300?text=Product+5'
        },
        {
          'title': 'Placeholder Product 6',
          'price': '£22.00',
          'originalPrice': '£38.00',
          'image': 'https://via.placeholder.com/400x300?text=Product+6'
        },
      ];
    } else {
      products = List.generate(
          6,
          (i) => {
                'title': 'Placeholder Product ${i + 1}',
                'price': '£${(10 + i * 5).toStringAsFixed(2)}',
                'originalPrice': '£${(10 + i * 5).toStringAsFixed(2)}',
                'image':
                    'https://via.placeholder.com/400x300?text=Product+${i + 1}'
              });
    }

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

            // dummy filter dropdown (non-functional)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filter by:',
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
                children: products.map((p) {
                  final isDiscounted =
                      (p['originalPrice'] ?? '') != (p['price'] ?? '');
                  return Card(
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
