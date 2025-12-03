import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  group('Home Page Tests', () {
    testWidgets('renders hero and products section', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Hero carousel headline on first slide
      expect(find.text('On Sale Now!'), findsOneWidget);

      // Products section header
      expect(find.text('PRODUCTS SECTION'), findsOneWidget);
    });

    testWidgets('shows header icons', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      // Menu appears on narrow screens via MobileDrawer icon button
      expect(find.byIcon(Icons.menu), findsNothing);
    });

    testWidgets('displays base product titles and prices', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // From lib/data/products.dart
      expect(find.text('Sage Hoodie'), findsOneWidget);
      expect(find.text('Grey Hoodie'), findsOneWidget);
      expect(find.text('Signature T-Shirt Indigo Blue'), findsOneWidget);

      expect(find.text('£45.00'), findsNWidgets(3));
      expect(find.text('£20.00'), findsOneWidget);
    });
  });
}
