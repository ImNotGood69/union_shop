import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final collections = [
      {
        'title': 'Autumn Favourites',
        'image': 'https://via.placeholder.com/400x300?text=Autumn+Favourites'
      },
      {
        'title': 'Black Friday',
        'image': 'https://via.placeholder.com/400x300?text=Black+Friday'
      },
      {
        'title': 'Winter Warmers',
        'image': 'https://via.placeholder.com/400x300?text=Winter+Warmers'
      },
      {
        'title': 'Summer Sale',
        'image': 'https://via.placeholder.com/400x300?text=Summer+Sale'
      },
      {
        'title': 'New Arrivals',
        'image': 'https://via.placeholder.com/400x300?text=New+Arrivals'
      },
      {
        'title': 'Staff Picks',
        'image': 'https://via.placeholder.com/400x300?text=Staff+Picks'
      },
      {
        'title': 'Gift Ideas',
        'image': 'https://via.placeholder.com/400x300?text=Gift+Ideas'
      },
      {
        'title': 'Limited Edition',
        'image': 'https://via.placeholder.com/400x300?text=Limited+Edition'
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
          crossAxisCount: MediaQuery.of(context).size.width > 1200
              ? 4
              : (MediaQuery.of(context).size.width > 800
                  ? 3
                  : (MediaQuery.of(context).size.width > 600 ? 2 : 1)),
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: collections.map((c) {
            return InkWell(
              onTap: () => Navigator.pushNamed(context, '/collections/detail',
                  arguments: c),
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Image.network(
                        c['image']!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey[300]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      child: Text(c['title']!,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
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
