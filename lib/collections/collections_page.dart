import 'package:flutter/material.dart';
import 'package:union_shop/widgets/header_bar.dart';
import 'package:union_shop/widgets/mobile_drawer.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final collections = [
      {
        'title': 'Autumn Favourites',
        'image':
            'https://shop.upsu.net/cdn/shop/files/SageHoodie_530x530@2x.png?v=1745583498'
      },
      {
        'title': 'On sale!',
        'image':
            'https://media.posterstore.com/site_images/686306ea92c536b9cc92ab5f_235008937_PS53025-5.jpg?auto=compress%2Cformat&fit=max&w=3840'
      },
      {
        'title': 'Winter Warmers',
        'image':
            'https://images.squarespace-cdn.com/content/v1/552f35bee4b0955308211538/1464586967921-3GHDHTJ8W2IXCNHQ5KB7/Yummy+Dogs+-+Winter+Warmers+The+Cold+Weather+Party+Guide.jpg?format=1000w'
      },
      {
        'title': 'Summer Sale',
        'image':
            'https://images.pexels.com/photos/33044/sunflower-sun-summer-yellow.jpg?cs=srgb&dl=pexels-pixabay-33044.jpg&fm=jpg'
      },
      {
        'title': 'New Arrivals',
        'image':
            'https://shop.upsu.net/cdn/shop/files/GreyHoodieFinal_1024x1024@2x.jpg?v=1742201957'
      },
      {
        'title': 'Staff Picks',
        'image':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxjQc4yYW3O8ar5THil6vIY_hw2Xat5xiWig&s'
      },
      {
        'title': 'Gift Ideas',
        'image':
            'https://media.istockphoto.com/id/1824629274/photo/christmas-gift-boxes-festive-wrapped-presents-composition-winter-holiday-season-gifts.jpg?s=612x612&w=0&k=20&c=2NeA7WaSzKuI6XNBZKbfukyIOXX3TSKzvEX0ADRoULk='
      },
      {
        'title': 'Limited Edition',
        'image':
            'https://shop.upsu.net/cdn/shop/products/GradPurple_1200x1200.png?v=1657288025'
      },
    ];

    return Scaffold(
      appBar: const HeaderBar(),
      drawer: const MobileDrawer(),
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
