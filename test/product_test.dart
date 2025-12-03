import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/providers/cart_provider.dart';

void main() {
  group('Product Page Tests', () {
    Widget createTestWidget() {
      return ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: const MaterialApp(home: ProductPage()),
      );
    }

    testWidgets('should display product page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Basic product UI elements
      expect(find.text('Placeholder Product Name'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display student instruction text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Size/quantity controls present
      expect(find.text('Size'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that header icons are present in product page header row
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Footer headings present
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Contact Us'), findsOneWidget);
    });
  });
}
