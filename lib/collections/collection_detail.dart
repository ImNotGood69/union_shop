import 'package:flutter/material.dart';

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
    final title = args?['title'] ?? 'Collection';
    final image =
        args?['image'] ?? 'https://via.placeholder.com/800x400?text=Collection';

    // placeholder product list for this collection
    final products = List.generate(
        6,
        (i) => {
              'title': 'Placeholder Product ${i + 1}',
              'price': '£${(10 + i * 5).toStringAsFixed(2)}',
              'image':
                  'https://via.placeholder.com/400x300?text=Product+${i + 1}'
            });

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: Column(
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    // dummy - does not change product list logic
                    setState(() => _selectedFilter = v ?? 'All');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // products grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 900
                    ? 3
                    : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 4,
                children: products.map((p) {
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Image.network(
                            p['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: Colors.grey[300]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(p['title']!,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(p['price']!,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
