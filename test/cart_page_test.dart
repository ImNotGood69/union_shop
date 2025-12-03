import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/cart/cart_page.dart';
import 'package:union_shop/providers/cart_provider.dart';

void main() {
  Widget createTestWidget({CartProvider? cartProvider}) {
    return ChangeNotifierProvider(
      create: (_) => cartProvider ?? CartProvider(),
      child: const MaterialApp(
        home: CartPage(),
      ),
    );
  }

  group('Empty Cart Tests', () {
    testWidgets('should display empty cart message when cart is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsAtLeastNWidgets(1));
      expect(find.text('Continue Shopping'), findsOneWidget);
    });

    testWidgets('should navigate to home when Continue Shopping is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
          child: MaterialApp(
            initialRoute: '/cart',
            routes: {
              '/': (context) => const Scaffold(
                    body: Center(child: Text('Home Page')),
                  ),
              '/cart': (context) => const CartPage(),
            },
          ),
        ),
      );

      await tester.tap(find.text('Continue Shopping'));
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
    });
  });

  group('Cart with Items Tests', () {
    testWidgets('should display cart items correctly',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('Test Hoodie'), findsOneWidget);
      expect(find.text('Size: M'), findsOneWidget);
      expect(find.text('£25.00'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display multiple items in cart',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );
      cart.addItem(
        productId: 'test-2',
        title: 'Test T-Shirt',
        price: '£15.00',
        imageUrl: 'https://example.com/image2.jpg',
        size: 'L',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('Test Hoodie'), findsOneWidget);
      expect(find.text('Test T-Shirt'), findsOneWidget);
      expect(find.text('Size: M'), findsOneWidget);
      expect(find.text('Size: L'), findsOneWidget);
    });

    testWidgets('should display item with original price strikethrough',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Sale Hoodie',
        price: '£20.00',
        originalPrice: '£30.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('Sale Hoodie'), findsOneWidget);
      expect(find.text('£20.00'), findsAtLeastNWidgets(1));
      expect(find.text('£30.00'), findsOneWidget);
    });

    testWidgets('should display correct item quantity',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      // Should show quantity of 2 (may appear in header badge too)
      expect(find.text('2'), findsAtLeastNWidgets(1));
    });
  });

  group('Quantity Control Tests', () {
    testWidgets('should increase quantity when plus button is pressed',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      // Initial quantity should be 1 (may appear in header badge too)
      expect(find.text('1'), findsAtLeastNWidgets(1));

      // Tap plus button
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pumpAndSettle();

      // Quantity should be 2
      expect(find.text('2'), findsAtLeastNWidgets(1));
      expect(cart.items.values.first.quantity, 2);
    });

    testWidgets('should decrease quantity when minus button is pressed',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );
      // Add again to make quantity 2
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      // Initial quantity should be 2 (may appear in header badge too)
      expect(find.text('2'), findsAtLeastNWidgets(1));

      // Tap minus button
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pumpAndSettle();

      // Quantity should be 1
      expect(find.text('1'), findsAtLeastNWidgets(1));
      expect(cart.items.values.first.quantity, 1);
    });

    testWidgets('should remove item when quantity reaches 0',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('Test Hoodie'), findsOneWidget);

      // Tap minus button to reduce from 1 to 0
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pumpAndSettle();

      // Item should be removed, empty cart message shown
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(cart.itemCount, 0);
    });

    testWidgets('should update total when quantity changes',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      // Initial total should be £25.00
      expect(find.text('£25.00'), findsAtLeastNWidgets(1));

      // Tap plus button to increase quantity
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pumpAndSettle();

      // Total should now be £50.00
      expect(find.text('£50.00'), findsAtLeastNWidgets(1));
    });
  });

  group('Remove Item Tests', () {
    testWidgets('should remove item when delete button is pressed',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('Test Hoodie'), findsOneWidget);

      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Item should be removed
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(cart.itemCount, 0);
    });

    testWidgets('should remove correct item when multiple items exist',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );
      cart.addItem(
        productId: 'test-2',
        title: 'Test T-Shirt',
        price: '£15.00',
        imageUrl: 'https://example.com/image2.jpg',
        size: 'L',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('Test Hoodie'), findsOneWidget);
      expect(find.text('Test T-Shirt'), findsOneWidget);

      // Tap delete button for first item
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      // First item should be removed, second should remain
      expect(find.text('Test Hoodie'), findsNothing);
      expect(find.text('Test T-Shirt'), findsOneWidget);
      expect(cart.itemCount, 1);
    });
  });

  group('Cart Summary Tests', () {
    testWidgets('should display correct subtotal', (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );
      cart.addItem(
        productId: 'test-2',
        title: 'Test T-Shirt',
        price: '£15.00',
        imageUrl: 'https://example.com/image2.jpg',
        size: 'L',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('Subtotal:'), findsOneWidget);
      expect(find.text('£40.00'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display correct total', (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('Total:'), findsOneWidget);
      expect(find.text('£25.00'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display Proceed to Checkout button',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('Proceed to Checkout'), findsOneWidget);
    });

    testWidgets('should show snackbar when checkout button is pressed',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      expect(find.text('Checkout functionality coming soon!'), findsOneWidget);
    });
  });

  group('UI Element Tests', () {
    testWidgets('should display product image', (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.byType(Image), findsAtLeastNWidgets(1));
    });

    testWidgets('should display quantity control buttons',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);
    });

    testWidgets('should display delete button', (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });
  });

  group('Edge Cases', () {
    testWidgets('should handle items with same product but different sizes',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'L',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      // Should show 2 separate items
      expect(find.text('Test Hoodie'), findsNWidgets(2));
      expect(find.text('Size: M'), findsOneWidget);
      expect(find.text('Size: L'), findsOneWidget);
      expect(cart.itemCount, 2);
    });

    testWidgets('should handle large quantities', (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£10.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      // Manually set large quantity
      final key = cart.items.keys.first;
      cart.updateQuantity(key, 10);

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('10'), findsAtLeastNWidgets(1));
      expect(find.text('£100.00'), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle decimal prices correctly',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£19.99',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      expect(find.text('£19.99'), findsAtLeastNWidgets(1));
    });

    testWidgets('should calculate total correctly with multiple items',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Hoodie',
        price: '£25.50',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );
      cart.addItem(
        productId: 'test-2',
        title: 'Test T-Shirt',
        price: '£14.50',
        imageUrl: 'https://example.com/image2.jpg',
        size: 'L',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      // Total should be 25.50 + 14.50 = 40.00
      expect(find.text('£40.00'), findsAtLeastNWidgets(1));
    });
  });
}
