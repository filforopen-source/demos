import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';
import 'package:go_router/go_router.dart';
import 'package:dash_shop/widgets/cart_fab.dart';
import 'package:dash_shop/view_models/cart_view_model.dart';
import 'package:dash_shop/repositories/cart_repository.dart';
import 'package:dash_shop/models/product.dart';

void main() {
  group('CartFab Widget Test', () {
    late CartViewModel cartViewModel;
    late Product product;

    setUp(() {
      cartViewModel = CartViewModel(CartRepository());
      product = const Product(
        id: '1',
        name: 'Test Product',
        description: 'A product for testing',
        price: 19.99,
        imageUrl: 'test.png',
        category: 'Test Category',
      );
    });

    Widget createFabUnderTest(GoRouter router) {
      return MaterialApp.router(
        routerConfig: router,
      );
    }

    testWidgets('renders only icon when cart is empty', (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(body: CartFab(viewModel: cartViewModel)),
          ),
        ],
      );

      await tester.pumpWidget(createFabUnderTest(router));

      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.text('\$19.99'), findsNothing);
    });

    testWidgets('expands and shows subtotal when items are added', (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(body: CartFab(viewModel: cartViewModel)),
          ),
        ],
      );

      await tester.pumpWidget(createFabUnderTest(router));

      // Add item to cart
      cartViewModel.addToCart(product);
      
      // Pump frames for ListenableBuilder / AnimatedSize animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300)); 

      expect(find.text('\$19.99'), findsOneWidget);
    });

    testWidgets('navigates to /cart when tapped', (WidgetTester tester) async {
      bool pushedCart = false;
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(body: CartFab(viewModel: cartViewModel)),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) {
              pushedCart = true;
              return const Scaffold(body: Text('Cart Screen'));
            },
          ),
        ],
      );

      await tester.pumpWidget(createFabUnderTest(router));

      await tester.tap(find.byType(CartFab));
      await tester.pumpAndSettle();

      check(pushedCart).isTrue();
      expect(find.text('Cart Screen'), findsOneWidget);
    });
  });
}
