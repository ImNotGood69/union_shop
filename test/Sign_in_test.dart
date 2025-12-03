import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/auth/sign_in_page.dart';
import 'package:union_shop/providers/cart_provider.dart';

void main() {
  Widget createTestWidget({CartProvider? cartProvider}) {
    return ChangeNotifierProvider(
      create: (_) => cartProvider ?? CartProvider(),
      child: const MaterialApp(
        home: SignInPage(),
      ),
    );
  }

  group('Sign In Page Display Tests', () {
    testWidgets('should display page title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('should display welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Welcome back'), findsOneWidget);
    });

    testWidgets('should display email text field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    });

    testWidgets('should display password text field',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    });

    testWidgets('should display submit button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.widgetWithText(ElevatedButton, 'Submit'), findsOneWidget);
    });

    testWidgets('should display cart icon in app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });
  });

  group('Email Field Widget Tests', () {
    testWidgets('should have email keyboard type', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final emailField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Email'),
      );

      expect(emailField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('should accept text input', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'test@example.com',
      );
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should have outlined border', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final emailField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Email'),
      );

      expect(
        emailField.decoration?.border.runtimeType,
        OutlineInputBorder,
      );
    });

    testWidgets('should clear when new text is entered',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final emailFinder = find.widgetWithText(TextField, 'Email');

      await tester.enterText(emailFinder, 'test@example.com');
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);

      await tester.enterText(emailFinder, 'new@example.com');
      await tester.pump();
      expect(find.text('new@example.com'), findsOneWidget);
      expect(find.text('test@example.com'), findsNothing);
    });
  });

  group('Password Field Widget Tests', () {
    testWidgets('should obscure text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );

      expect(passwordField.obscureText, true);
    });

    testWidgets('should accept text input', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );
      await tester.pump();

      // Text should be entered but obscured
      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(passwordField.controller?.text, 'password123');
    });

    testWidgets('should have outlined border', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );

      expect(
        passwordField.decoration?.border.runtimeType,
        OutlineInputBorder,
      );
    });

    testWidgets('should not display password as plain text',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'secretpass',
      );
      await tester.pump();

      // Verify the field has obscureText enabled
      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(passwordField.obscureText, true);
    });
  });

  group('Submit Button Widget Tests', () {
    testWidgets('should have correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final submitButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Submit'),
      );

      expect(submitButton.style?.backgroundColor?.resolve({}),
          const Color(0xFF4d2963));
      expect(submitButton.style?.foregroundColor?.resolve({}), Colors.white);
    });

    testWidgets('should be tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Button should be pressable without errors
    });

    testWidgets('should show snackbar when pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Signed in successfully'), findsOneWidget);
    });

    testWidgets('should dismiss snackbar after delay',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Signed in successfully'), findsOneWidget);

      // Wait for snackbar duration (SnackBar default is 4 seconds)
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text('Signed in successfully'), findsNothing);
    });
  });

  group('Form Submission Tests', () {
    testWidgets('should submit with empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Submit without entering any data
      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Signed in successfully'), findsOneWidget);
    });

    testWidgets('should submit with email only', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'test@example.com',
      );
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Signed in successfully'), findsOneWidget);
    });

    testWidgets('should submit with password only',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Signed in successfully'), findsOneWidget);
    });

    testWidgets('should submit with both fields filled',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Signed in successfully'), findsOneWidget);
    });
  });

  group('Cart Badge Widget Tests', () {
    testWidgets('should not display badge when cart is empty',
        (WidgetTester tester) async {
      final cart = CartProvider();
      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      // Badge should not be visible when cart is empty
      expect(find.text('0'), findsNothing);
      expect(cart.totalQuantity, 0);
    });

    testWidgets('should display badge when cart has items',
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

      // Badge should show item count
      expect(find.text('1'), findsAtLeastNWidgets(1));
      expect(cart.totalQuantity, 1);
    });

    testWidgets('should update badge when items are added',
        (WidgetTester tester) async {
      final cart = CartProvider();
      await tester.pumpWidget(createTestWidget(cartProvider: cart));

      // Initially no badge
      expect(cart.totalQuantity, 0);

      // Add item
      cart.addItem(
        productId: 'test-1',
        title: 'Test Product',
        price: '£10.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );
      await tester.pump();

      // Badge should appear
      expect(find.text('1'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display correct quantity in badge',
        (WidgetTester tester) async {
      final cart = CartProvider();
      cart.addItem(
        productId: 'test-1',
        title: 'Test Product',
        price: '£10.00',
        imageUrl: 'https://example.com/image.jpg',
        size: 'M',
      );
      cart.addItem(
        productId: 'test-2',
        title: 'Test Product 2',
        price: '£15.00',
        imageUrl: 'https://example.com/image2.jpg',
        size: 'L',
      );

      await tester.pumpWidget(createTestWidget(cartProvider: cart));
      await tester.pump();

      expect(find.text('2'), findsAtLeastNWidgets(1));
      expect(cart.totalQuantity, 2);
    });

    testWidgets('should navigate to cart when cart icon tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
          child: MaterialApp(
            initialRoute: '/signin',
            routes: {
              '/signin': (context) => const SignInPage(),
              '/cart': (context) => const Scaffold(
                    body: Center(child: Text('Cart Page')),
                  ),
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Cart Page'), findsOneWidget);
    });
  });

  group('UI Layout Tests', () {
    testWidgets('should display form in a card', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should have constrained width', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final constrainedBoxes = find.byType(ConstrainedBox);
      expect(constrainedBoxes, findsAtLeastNWidgets(1));

      final constrainedBox = tester
          .widgetList<ConstrainedBox>(constrainedBoxes)
          .firstWhere((box) => box.constraints.maxWidth == 420);

      expect(constrainedBox.constraints.maxWidth, 420);
    });

    testWidgets('should have proper spacing between elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check for SizedBox widgets that provide spacing
      expect(find.byType(SizedBox), findsAtLeastNWidgets(3));
    });

    testWidgets('should center content on screen', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });
  });

  group('Controller Tests', () {
    testWidgets('should have separate controllers for email and password',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final emailField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Email'),
      );
      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );

      expect(emailField.controller, isNotNull);
      expect(passwordField.controller, isNotNull);
      expect(emailField.controller, isNot(equals(passwordField.controller)));
    });

    testWidgets('should retain entered values', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );
      await tester.pump();

      final emailField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Email'),
      );
      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );

      expect(emailField.controller?.text, 'test@example.com');
      expect(passwordField.controller?.text, 'password123');
    });
  });

  group('Navigation Tests', () {
    testWidgets('should pop page after successful submission',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInPage(),
                      ),
                    ),
                    child: const Text('Go to Sign In'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Sign In'), findsOneWidget);

      // Submit form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Should return to previous page
      expect(find.text('Go to Sign In'), findsOneWidget);
    });
  });
}
