import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/print_shack/personalise_page.dart';
import 'package:union_shop/providers/cart_provider.dart';

void main() {
  Widget createTestWidget() {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MaterialApp(
        home: PersonalisePage(),
      ),
    );
  }

  Future<void> scrollToWidget(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      100,
      scrollable: find.byType(Scrollable).first,
    );
  }

  testWidgets('should display page title', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Personalise Your Clothes'), findsOneWidget);
  });

  testWidgets('should display hoodie image', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(Image), findsAtLeastNWidgets(1));
  });

  testWidgets('should display size dropdown with default M',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Size'), findsOneWidget);
    expect(find.text('M'), findsOneWidget);
  });

  testWidgets('should allow size selection', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final sizeDropdown = find
        .ancestor(
          of: find.text('M'),
          matching: find.byType(DropdownButton<String>),
        )
        .first;
    await scrollToWidget(tester, sizeDropdown);

    await tester.tap(find.text('M'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('XL').last);
    await tester.pumpAndSettle();

    expect(find.text('XL'), findsOneWidget);
  });

  testWidgets('should display all size options in dropdown',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final sizeDropdown = find
        .ancestor(
          of: find.text('M'),
          matching: find.byType(DropdownButton<String>),
        )
        .first;
    await scrollToWidget(tester, sizeDropdown);

    await tester.tap(find.text('M'));
    await tester.pumpAndSettle();

    expect(find.text('XS'), findsOneWidget);
    expect(find.text('S'), findsOneWidget);
    expect(find.text('M'), findsAtLeastNWidgets(1));
    expect(find.text('L'), findsOneWidget);
    expect(find.text('XL'), findsOneWidget);
    expect(find.text('XXL'), findsOneWidget);
  });

  testWidgets('should display number of lines dropdown with default 1 line',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Number of Text Lines'), findsOneWidget);
    expect(find.text('1 line'), findsOneWidget);
  });

  testWidgets('should allow changing number of text lines',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(TextField), findsOneWidget);

    await scrollToWidget(tester, find.text('1 line'));
    await tester.tap(find.text('1 line'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('3 lines').last);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.text('Line 1'), findsOneWidget);
    expect(find.text('Line 2'), findsOneWidget);
    expect(find.text('Line 3'), findsOneWidget);
  });

  testWidgets('should display initial price of £10.00',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Total Price:'), findsOneWidget);
    expect(find.text('£10.00'), findsOneWidget);
  });

  testWidgets('should update price when number of lines changes',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await scrollToWidget(tester, find.text('Total Price:'));

    expect(find.text('£10.00'), findsOneWidget);

    await scrollToWidget(tester, find.text('1 line'));
    await tester.tap(find.text('1 line'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 lines').last);
    await tester.pumpAndSettle();

    await scrollToWidget(tester, find.text('Total Price:'));
    expect(find.text('£20.00'), findsOneWidget);

    await scrollToWidget(tester, find.text('2 lines'));
    await tester.tap(find.text('2 lines'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('3 lines').last);
    await tester.pumpAndSettle();

    await scrollToWidget(tester, find.text('Total Price:'));
    expect(find.text('£30.00'), findsOneWidget);
  });

  testWidgets('should display Add to Cart button', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Add to Cart'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('should show error when adding empty text to cart',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await scrollToWidget(tester, find.text('Add to Cart'));

    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter at least one line of text'), findsOneWidget);
  });

  testWidgets('should add item to cart when text is entered',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await scrollToWidget(tester, find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'My Custom Text');
    await tester.pumpAndSettle();

    await scrollToWidget(tester, find.text('Add to Cart'));

    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Added to cart'), findsOneWidget);
  });

  testWidgets('should clear text fields after adding to cart',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await scrollToWidget(tester, find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Test Text');
    await tester.pumpAndSettle();

    await scrollToWidget(tester, find.text('Add to Cart'));
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle(const Duration(seconds: 3));

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller?.text, isEmpty);
  });

  testWidgets('should add item to cart with correct details',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    final cartProvider = Provider.of<CartProvider>(
        tester.element(find.byType(PersonalisePage)),
        listen: false);

    final sizeDropdown = find
        .ancestor(
          of: find.text('M'),
          matching: find.byType(DropdownButton<String>),
        )
        .first;
    await scrollToWidget(tester, sizeDropdown);
    await tester.tap(find.text('M'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('L').last);
    await tester.pumpAndSettle();

    await scrollToWidget(tester, find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Custom Hoodie');
    await tester.pumpAndSettle();

    await scrollToWidget(tester, find.text('Add to Cart'));
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    expect(cartProvider.itemCount, 1);
    final cartItems = cartProvider.items.values.toList();
    expect(cartItems[0].title, 'Personalised Hoodie');
    expect(cartItems[0].price, '£10.00');
    expect(cartItems[0].size, 'L');
    expect(cartItems[0].description, contains('Custom Hoodie'));
  });

  testWidgets('should add item with multiple lines to cart',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    final cartProvider = Provider.of<CartProvider>(
        tester.element(find.byType(PersonalisePage)),
        listen: false);

    await scrollToWidget(tester, find.text('1 line'));
    await tester.tap(find.text('1 line'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 lines').last);
    await tester.pumpAndSettle();

    final textFields = find.byType(TextField);
    await scrollToWidget(tester, textFields.first);
    await tester.enterText(textFields.at(0), 'Line One');
    await tester.pumpAndSettle();
    await tester.enterText(textFields.at(1), 'Line Two');
    await tester.pumpAndSettle();

    await scrollToWidget(tester, find.text('Add to Cart'));
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    expect(cartProvider.itemCount, 1);
    final cartItems = cartProvider.items.values.toList();
    expect(cartItems[0].price, '£20.00');
    expect(cartItems[0].description, contains('Line One | Line Two'));
  });

  testWidgets('should handle empty lines correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await scrollToWidget(tester, find.text('1 line'));
    await tester.tap(find.text('1 line'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 lines').last);
    await tester.pumpAndSettle();

    final textFields = find.byType(TextField);
    await scrollToWidget(tester, textFields.first);
    await tester.enterText(textFields.at(0), 'Only First Line');
    await tester.pumpAndSettle();

    await scrollToWidget(tester, find.text('Add to Cart'));
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Added to cart'), findsOneWidget);
  });
}
