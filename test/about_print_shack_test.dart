import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/print_shack/about_print_shack_page.dart';
import 'package:union_shop/providers/cart_provider.dart';

void main() {
  Widget createTestWidget({CartProvider? cartProvider}) {
    return ChangeNotifierProvider(
      create: (_) => cartProvider ?? CartProvider(),
      child: const MaterialApp(
        home: AboutPrintShackPage(),
      ),
    );
  }

  testWidgets('should display key content and headings',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('About The Print Shack'), findsOneWidget);
    expect(find.text('The Print Shack'), findsOneWidget);
    expect(find.text('Your personalisation destination!'), findsOneWidget);
    expect(find.textContaining('exclusive personalisation services'),
        findsOneWidget);
    expect(find.textContaining('printshack@upsu.net'), findsOneWidget);
  });

  testWidgets('should display cart badge when items in cart',
      (WidgetTester tester) async {
    final cart = CartProvider();
    cart.addItem(
      productId: 'test-1',
      title: 'Test Product',
      price: '£10.00',
      imageUrl: 'https://example.com/image.jpg',
      size: 'M',
    );

    await tester.pumpWidget(createTestWidget(cartProvider: cart));
    await tester.pump();

    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    expect(find.text('1'), findsAtLeastNWidgets(1));
  });

  testWidgets('should be scrollable for long content',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(Column), findsAtLeastNWidgets(1));
  });
}
