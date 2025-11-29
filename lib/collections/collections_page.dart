import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final collections = [
      {
        'title': 'Autumn Favourites',
        'image': 'https://via.placeholder.com/600x400?text=Autumn+Favourites'
      },
      {
        'title': 'Black Friday',
        'image': 'https://via.placeholder.com/600x400?text=Black+Friday'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4d2963),
        title: const Text('Collections'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 2 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: collections.map((c) {
            return InkWell(
              onTap: () => Navigator.pushNamed(context, '/collections/detail',
                  arguments: c),
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        c['image']!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey[300]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(c['title']!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
