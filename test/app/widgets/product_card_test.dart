import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest/app/widgets/product_card.dart';

void main() {
  Widget buildCard({VoidCallback? onAddToCart, int cartQuantity = 0}) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 200,
          height: 280,
          child: ProductCard(
            name: 'Tomato',
            price: 3.99,
            unit: 'kg',
            imageUrl: '',
            farmName: 'Green Farm',
            onTap: () {},
            onAddToCart: onAddToCart,
            cartQuantity: cartQuantity,
          ),
        ),
      ),
    );
  }

  group('ProductCard add-to-cart button', () {
    testWidgets('shows add button when onAddToCart is provided', (
      tester,
    ) async {
      await tester.pumpWidget(buildCard(onAddToCart: () {}));

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('does not show add button when onAddToCart is null', (
      tester,
    ) async {
      await tester.pumpWidget(buildCard());

      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('tapping the add button calls onAddToCart', (tester) async {
      var called = false;
      await tester.pumpWidget(buildCard(onAddToCart: () => called = true));

      await tester.tap(find.byType(IconButton));

      expect(called, isTrue);
    });

    testWidgets('shows cart quantity badge when cartQuantity > 0', (
      tester,
    ) async {
      await tester.pumpWidget(buildCard(onAddToCart: () {}, cartQuantity: 3));

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('does not show badge when cartQuantity is 0', (tester) async {
      await tester.pumpWidget(buildCard(onAddToCart: () {}));

      expect(find.text('0'), findsNothing);
    });
  });
}
