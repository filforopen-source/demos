import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/cart_view_model.dart';
import 'view_models/catalog_view_model.dart';
import 'services/auth_api_service.dart';
import 'services/catalog_api_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/catalog_repository.dart';
import 'repositories/cart_repository.dart';
import 'router.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  final authService = AuthApiService();
  final catalogService = CatalogApiService();

  final authRepository = AuthRepository(authService);
  final catalogRepository = CatalogRepository(catalogService);
  final cartRepository = CartRepository();

  final authViewModel = AuthViewModel(authRepository);
  final catalogViewModel = CatalogViewModel(catalogRepository);
  final cartViewModel = CartViewModel(cartRepository);

  runApp(
    DashShopApp(
      authViewModel: authViewModel,
      catalogViewModel: catalogViewModel,
      cartViewModel: cartViewModel,
    ),
  );
}

class DashShopApp extends StatefulWidget {
  final AuthViewModel authViewModel;
  final CatalogViewModel catalogViewModel;
  final CartViewModel cartViewModel;

  const DashShopApp({
    super.key,
    required this.authViewModel,
    required this.catalogViewModel,
    required this.cartViewModel,
  });

  @override
  State<DashShopApp> createState() => _DashShopAppState();
}

class _DashShopAppState extends State<DashShopApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(
      widget.authViewModel,
      widget.catalogViewModel,
      widget.cartViewModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlack = Colors.black;

    final theme = ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(
        Theme.of(context).textTheme,
      ).apply(bodyColor: Colors.black, displayColor: Colors.black),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlack,
        primary: primaryBlack,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryBlack.withValues(alpha: 0.1),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryBlack);
          }
          return const IconThemeData(color: Colors.grey);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primaryBlack,
              fontWeight: FontWeight.bold,
            );
          }
          return const TextStyle(color: Colors.grey);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlack,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );

    return MaterialApp.router(
      title: 'The Dash Shop',
      theme: theme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
