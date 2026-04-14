import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/cart_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/cart_view_model.dart';
import 'view_models/catalog_view_model.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorHomeKey = GlobalKey<NavigatorState>();
final shellNavigatorShopKey = GlobalKey<NavigatorState>();
final shellNavigatorCartKey = GlobalKey<NavigatorState>();
final shellNavigatorProfileKey = GlobalKey<NavigatorState>();

GoRouter createRouter(
  AuthViewModel authViewModel,
  CatalogViewModel catalogViewModel,
  CartViewModel cartViewModel,
) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.shop), label: 'Shop'),
                NavigationDestination(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              onDestinationSelected: (index) => navigationShell.goBranch(index),
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => HomeScreen(
                  catalogViewModel: catalogViewModel,
                  cartViewModel: cartViewModel,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorShopKey,
            routes: [
              GoRoute(
                path: '/shop',
                builder: (context, state) => CatalogScreen(
                  viewModel: catalogViewModel,
                  cartViewModel: cartViewModel,
                  initialCategory: state.uri.queryParameters['category'],
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorCartKey,
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) =>
                    CartScreen(viewModel: cartViewModel),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) =>
                    ProfileScreen(viewModel: authViewModel),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            CheckoutScreen(cartViewModel: cartViewModel),
      ),
      GoRoute(
        path: '/shop/product/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ProductDetailScreen(
          productId: state.pathParameters['id']!,
          viewModel: catalogViewModel,
          cartViewModel: cartViewModel,
        ),
      ),
    ],
  );
}
