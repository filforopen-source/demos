import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dash_shop/screens/cart_screen.dart';
import 'package:dash_shop/screens/checkout_screen.dart';
import 'package:dash_shop/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Checkout Flow', () {
    testWidgets('Add item to cart and complete checkout', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Add Dash Plushie to cart
      final addPlushieButton = find.byKey(const Key('product_add_dash-plush'));
      await tester.tap(addPlushieButton);
      await tester.pumpAndSettle();

      // 2. Open cart via FAB
      final cartFab = find.byKey(const Key('cart_fab'));
      await tester.tap(cartFab);
      await tester.pumpAndSettle();

      // 3. Verify on Cart screen and tap 'Go to checkout'
      expect(find.byType(CartScreen), findsOneWidget);
      final checkoutButton = find.byKey(const Key('checkoutButton'));
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.byType(CheckoutScreen), findsOneWidget);

      // 4. Fill in shipping information
      await tester.enterText(find.byKey(const Key('fullNameField')), 'Dash');
      await tester.enterText(find.byKey(const Key('addressField')), '123 Dart Lane');
      await tester.enterText(find.byKey(const Key('cityField')), 'Mountain View');
      await tester.enterText(find.byKey(const Key('stateField')), 'CA');
      await tester.enterText(find.byKey(const Key('zipField')), '94043');
      await tester.enterText(find.byKey(const Key('phoneField')), '555-555-5555');

      // 5. Fill in payment information
      await tester.enterText(find.byKey(const Key('cardNumberField')), '1234567812345678');
      await tester.enterText(find.byKey(const Key('expiryField')), '12/25');
      await tester.enterText(find.byKey(const Key('cvvField')), '123');

      // Scroll down to make sure Place Order is visible if needed
      await tester.dragUntilVisible(
        find.byKey(const Key('placeOrderButton')),
        find.byType(CustomScrollView),
        const Offset(0, -200),
      );

      // 6. Place order
      final placeOrderButton = find.byKey(const Key('placeOrderButton'));
      await tester.tap(placeOrderButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 7. Verify order completion (assuming it navigates back or shows success)
      // For now, we'll verify that the checkout screen is gone or a success message appeared.
      // Based on my exploration, I'll see if 'Checkout' is still there.
      expect(find.text('Checkout'), findsNothing);
    });
  });
}
