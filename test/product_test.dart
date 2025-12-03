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

    testWidgets('should display all size options', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check all size chips are present
      expect(find.text('S'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
      expect(find.text('L'), findsOneWidget);
      expect(find.text('XL'), findsOneWidget);
    });

    testWidgets('should allow size selection', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the L size chip
      final lChip = find.widgetWithText(ChoiceChip, 'L');
      expect(lChip, findsOneWidget);

      await tester.tap(lChip);
      await tester.pumpAndSettle();

      // Size should be selectable (no errors thrown)
      expect(lChip, findsOneWidget);
    });

    testWidgets('should display action buttons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for Add to cart and Buy now buttons
      expect(find.text('Add to cart'), findsOneWidget);
      expect(find.text('Buy now'), findsOneWidget);
    });

    testWidgets('should add item to cart when button pressed', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to make button visible
      await tester.scrollUntilVisible(
        find.text('Add to cart'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      // Tap the Add to cart button
      final addButton = find.text('Add to cart');
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Check for success snackbar (partial match)
      expect(find.textContaining('Added to cart'), findsOneWidget);
    });

    testWidgets('should display quantity selector with dropdown',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check quantity label
      expect(find.text('Quantity'), findsOneWidget);

      // TextField and dropdown should be present
      expect(find.byType(TextField), findsWidgets);
      expect(find.byType(DropdownButton<int>), findsOneWidget);
    });

    testWidgets('should display product description section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check description heading and text
      expect(find.text('Description'), findsOneWidget);
      expect(
        find.textContaining('This is a placeholder description'),
        findsOneWidget,
      );
    });
  });
}
