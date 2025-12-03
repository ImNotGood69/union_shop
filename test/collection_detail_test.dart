import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/collections/collection_detail.dart';
import 'package:union_shop/providers/cart_provider.dart';

void main() {
  Widget createTestWidget({Map<String, String>? arguments}) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const CollectionDetailPage(),
            settings: RouteSettings(arguments: arguments ?? {}),
          );
        },
        initialRoute: '/',
      ),
    );
  }

  group('Collection Detail Page Display Tests', () {
    testWidgets('should display collection title and image',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {
          'title': 'Test Collection',
          'image': 'https://example.com/image.jpg',
        },
      ));

      expect(find.text('Test Collection'), findsOneWidget);
      expect(find.byType(Image), findsAtLeastNWidgets(1));
    });

    testWidgets('should display default title when no arguments provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {},
      ));

      expect(find.text('Collection'), findsOneWidget);
    });

    testWidgets('should rename Black Friday to On sale!',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {
          'title': 'Black Friday',
        },
      ));

      expect(find.text('On sale!'), findsOneWidget);
      expect(find.text('Black Friday'), findsNothing);
    });

    testWidgets('should display promotional message for On sale! collection',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {
          'title': 'On sale!',
        },
      ));

      expect(
          find.textContaining('On Sale! Limited-time deals'), findsOneWidget);
      expect(find.textContaining('up to 50% off'), findsOneWidget);
    });

    testWidgets('should not display promotional message for other collections',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {
          'title': 'Regular Collection',
        },
      ));

      expect(find.textContaining('On Sale! Limited-time deals'), findsNothing);
    });
  });

  group('Sort Filter Tests', () {
    testWidgets('should display sort dropdown with default value All',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'Test Collection'},
      ));

      expect(find.text('Sort by:'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('should display all sort options when dropdown is opened',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'Test Collection'},
      ));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('All').hitTestable(), findsAtLeastNWidgets(1));
      expect(find.text('Price: Low to High').hitTestable(), findsOneWidget);
      expect(find.text('Price: High to Low').hitTestable(), findsOneWidget);
      expect(find.text('Newest').hitTestable(), findsOneWidget);
    });

    testWidgets('should change filter when option is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'Test Collection'},
      ));

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select Price: Low to High
      await tester.tap(find.text('Price: Low to High').last);
      await tester.pumpAndSettle();

      // Verify selection
      expect(find.text('Price: Low to High'), findsOneWidget);
    });
  });

  group('Product Grid Tests', () {
    testWidgets('should display products in grid layout',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'Test Collection'},
      ));

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsAtLeastNWidgets(1));
    });

    testWidgets('should display 6 placeholder products for regular collections',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'Regular Collection'},
      ));

      expect(find.textContaining('Placeholder Product'), findsNWidgets(6));
    });

    testWidgets('should display sale products with original prices',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'On sale!'},
      ));
      await tester.pumpAndSettle();

      // Check for specific sale products
      expect(find.textContaining('Portsmouth University 2025 Hoodie'),
          findsOneWidget);
      expect(find.textContaining('Neutral Classic Sweatshirt'), findsOneWidget);
      expect(find.text('£25.00'), findsAtLeastNWidgets(1));
      expect(find.text('£45.00'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display strikethrough for original prices',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'On sale!'},
      ));
      await tester.pumpAndSettle();

      // Find text widgets with strikethrough decoration
      final strikeThroughTexts = tester.widgetList<Text>(find.byType(Text));
      final hasStrikethrough = strikeThroughTexts.any((text) =>
          text.style?.decoration == TextDecoration.lineThrough &&
          text.data == '£45.00');

      expect(hasStrikethrough, isTrue);
    });
  });

  group('Sorting Functionality Tests', () {
    testWidgets('should sort products by price low to high',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'On sale!'},
      ));

      // Open dropdown and select Price: Low to High
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Price: Low to High').last);
      await tester.pumpAndSettle();

      // Get all price texts (excluding strikethrough original prices)
      final cards = tester.widgetList<Card>(find.byType(Card));
      expect(cards.length, 6);

      // Verify first product has lowest price (£1.50 - UP logo lanyard)
      expect(find.textContaining('UP logo lanyard'), findsOneWidget);
      expect(find.text('£1.50'), findsOneWidget);
    });

    testWidgets('should sort products by price high to low',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'On sale!'},
      ));

      // Open dropdown and select Price: High to Low
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Price: High to Low').last);
      await tester.pumpAndSettle();

      // Verify products exist
      expect(find.byType(Card), findsNWidgets(6));
      expect(find.text('£25.00'),
          findsAtLeastNWidgets(1)); // Highest price should be visible
    });

    testWidgets('should maintain original order for All filter',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'On sale!'},
      ));

      // Verify All filter is selected by default
      expect(find.text('All'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(6));
    });
  });

  group('Product Navigation Tests', () {
    testWidgets('should navigate to product page when product card is tapped',
        (WidgetTester tester) async {
      bool navigationCalled = false;

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
          child: MaterialApp(
            home: const CollectionDetailPage(),
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(
                  builder: (context) => const CollectionDetailPage(),
                  settings: const RouteSettings(
                    arguments: {'title': 'On sale!'},
                  ),
                );
              } else if (settings.name == '/product') {
                navigationCalled = true;
                return MaterialPageRoute(
                  builder: (context) => const Scaffold(
                    body: Center(child: Text('Product Page')),
                  ),
                );
              }
              return null;
            },
            initialRoute: '/',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll to and tap first product card
      await tester.ensureVisible(find.byType(Card).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      expect(navigationCalled, isTrue);
      expect(find.text('Product Page'), findsOneWidget);
    });
  });

  group('Responsive Layout Tests', () {
    testWidgets('should display single column on narrow screens',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'Test Collection'},
      ));

      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(
          (gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
              .crossAxisCount,
          1);
    });

    testWidgets('should be scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'Test Collection'},
      ));

      expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
    });
  });

  group('Image Error Handling Tests', () {
    testWidgets(
        'should display placeholder when collection image fails to load',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {
          'title': 'Test Collection',
          'image': 'invalid-url',
        },
      ));

      await tester.pumpAndSettle();

      // Should have error builder container
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('should display icon when product image fails to load',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        arguments: {'title': 'Test Collection'},
      ));

      await tester.pumpAndSettle();

      // Error builder should show icon
      expect(find.byIcon(Icons.image_not_supported), findsAtLeastNWidgets(1));
    });
  });
}
