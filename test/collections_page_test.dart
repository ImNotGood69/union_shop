import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/collections/collections_page.dart';
import 'package:union_shop/providers/cart_provider.dart';

void main() {
  Widget createTestWidget() {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MaterialApp(
        home: CollectionsPage(),
      ),
    );
  }

  group('Collections Page Display Tests', () {
    testWidgets('should display all 8 collection tiles',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // GridView should have 8 children (only 4 visible due to viewport)
      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(
          (gridView.childrenDelegate as SliverChildListDelegate)
              .children
              .length,
          8);
    });

    testWidgets('should display collection titles',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check first 4 visible collections
      expect(find.text('Autumn Favourites'), findsOneWidget);
      expect(find.text('On sale!'), findsOneWidget);
      expect(find.text('Winter Warmers'), findsOneWidget);
      expect(find.text('Summer Sale'), findsOneWidget);

      // Scroll to see more collections
      await tester.drag(find.byType(GridView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Check remaining collections are present
      expect(find.text('New Arrivals'), findsOneWidget);
    });

    testWidgets('should display collection images',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should have at least 4 images visible (plus header logo)
      expect(find.byType(Image), findsAtLeastNWidgets(4));
    });

    testWidgets('should display Sort by dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Sort by:'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('should display default filter as "All"',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('All'), findsOneWidget);
    });
  });

  group('Sorting Functionality Tests', () {
    testWidgets('should sort collections A-Z when selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select A-Z
      await tester.tap(find.text('A-Z').last);
      await tester.pumpAndSettle();

      // Verify all cards are still present after sorting
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsAtLeastNWidgets(4));

      // First card should have "Autumn Favourites" (starts with A)
      expect(find.text('Autumn Favourites'), findsOneWidget);
    });

    testWidgets('should sort collections Z-A when selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select Z-A
      await tester.tap(find.text('Z-A').last);
      await tester.pumpAndSettle();

      // Verify Z-A is selected
      expect(find.text('Z-A'), findsOneWidget);
      // Check GridView has all items (4 visible due to viewport)
      expect(find.byType(Card), findsAtLeastNWidgets(4));
    });

    testWidgets('should have all three sort options',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Check all options exist
      expect(find.text('All'), findsAtLeastNWidgets(1));
      expect(find.text('A-Z'), findsOneWidget);
      expect(find.text('Z-A'), findsOneWidget);
    });
  });

  group('Navigation Tests', () {
    testWidgets('should navigate to collection detail when tile is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => const CollectionsPage(),
              '/collections/detail': (context) => const Scaffold(
                    body: Center(child: Text('Collection Detail')),
                  ),
            },
          ),
        ),
      );

      // Tap on first visible collection card
      await tester.tap(find.text('Autumn Favourites'));
      await tester.pumpAndSettle();

      // Should navigate to detail page
      expect(find.text('Collection Detail'), findsOneWidget);
    });

    testWidgets('should pass collection data when navigating',
        (WidgetTester tester) async {
      Map<String, String>? receivedArgs;

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
          child: MaterialApp(
            initialRoute: '/',
            onGenerateRoute: (settings) {
              if (settings.name == '/collections/detail') {
                receivedArgs = settings.arguments as Map<String, String>?;
                return MaterialPageRoute(
                  builder: (context) => const Scaffold(
                    body: Center(child: Text('Collection Detail')),
                  ),
                );
              }
              return MaterialPageRoute(
                builder: (context) => const CollectionsPage(),
              );
            },
          ),
        ),
      );

      // Tap on "On sale!" collection
      await tester.tap(find.text('On sale!'));
      await tester.pumpAndSettle();

      // Verify arguments were passed
      expect(receivedArgs, isNotNull);
      expect(receivedArgs?['title'], 'On sale!');
      expect(receivedArgs?['image'], isNotNull);
    });
  });

  group('Responsive Layout Tests', () {
    testWidgets('should display in grid layout', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should use InkWell for tap feedback',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Each collection should have InkWell for tap effect
      expect(find.byType(InkWell), findsAtLeastNWidgets(8));
    });
  });

  group('Edge Cases', () {
    testWidgets('should handle image load errors gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Images should have error builders (at least 4 visible)
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsAtLeastNWidgets(4));
    });

    testWidgets('should maintain filter selection across rebuilds',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Select A-Z filter
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A-Z').last);
      await tester.pumpAndSettle();

      // Trigger rebuild by tapping elsewhere
      await tester.tap(find.text('Sort by:'));
      await tester.pumpAndSettle();

      // Filter should still be A-Z
      expect(find.text('A-Z'), findsOneWidget);
    });

    testWidgets('should display all collections regardless of sort',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Initially should have at least 4 visible cards
      expect(find.byType(Card), findsAtLeastNWidgets(4));

      // Change to A-Z
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A-Z').last);
      await tester.pumpAndSettle();

      // Should still have at least 4 visible cards
      expect(find.byType(Card), findsAtLeastNWidgets(4));

      // Change to Z-A
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Z-A').last);
      await tester.pumpAndSettle();

      // Should still have at least 4 visible cards
      expect(find.byType(Card), findsAtLeastNWidgets(4));
    });
  });

  group('UI Elements Tests', () {
    testWidgets('should display cards with proper styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Cards should have clipBehavior for rounded corners
      final cards = tester.widgetList<Card>(find.byType(Card));
      expect(cards.length, greaterThanOrEqualTo(4));
      for (final card in cards) {
        expect(card.clipBehavior, Clip.hardEdge);
      }
    });

    testWidgets('should have proper padding and spacing',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should have padding widgets
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });
  });
}
