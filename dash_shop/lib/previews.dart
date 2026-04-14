import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'widgets/dash_button.dart';
import 'widgets/cart_fab.dart';
import 'widgets/product_card.dart';
import 'models/product.dart';
import 'repositories/cart_repository.dart';
import 'view_models/cart_view_model.dart';

/// A custom preview annotation that provides the Dash Shop theme.
final class DashPreview extends Preview {
  const DashPreview({
    super.name,
    super.group,
    super.size,
    super.textScaleFactor,
    super.brightness,
  }) : super(theme: _themeBuilder, wrapper: _buildWrapper);

  static PreviewThemeData _themeBuilder() {
    const dashBlue = Color(0xFF00B2FF);
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: dashBlue,
        primary: dashBlue,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: dashBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
      ),
    );
    return PreviewThemeData(
      materialLight: theme,
      materialDark: theme, // You could add a dark theme here if needed
    );
  }

  static Widget _buildWrapper(Widget child) {
    return Scaffold(body: Center(child: child));
  }
}

// --- DashButton Previews ---

@DashPreview(name: 'Primary Button')
Widget primaryButton() => DashButton(label: 'Add to Cart', onPressed: () {});

@DashPreview(name: 'Secondary Button')
Widget secondaryButton() =>
    DashButton(label: 'View Details', isPrimary: false, onPressed: () {});

@DashPreview(name: 'Disabled Button')
Widget disabledButton() =>
    const DashButton(label: 'Out of Stock', onPressed: null);

// --- CartFab Previews ---

@DashPreview(name: 'Empty Cart')
Widget emptyCart() => CartFab(viewModel: CartViewModel(CartRepository()));

@DashPreview(name: 'Cart with Items')
Widget cartWithItems() {
  final vm = CartViewModel(CartRepository());
  vm.addToCart(
    Product(
      id: '1',
      name: 'Dash Plushie',
      description: 'A cute dash plushie',
      price: 19.99,
      imageUrl: 'assets/images/dash.png',
      category: 'Toys',
    ),
  );
  return CartFab(viewModel: vm);
}

// --- ProductCard Previews ---

@DashPreview(name: 'Product Card - Standard')
Widget productCard() => SizedBox(
  width: 200,
  height: 300,
  child: ProductCard(
    product: Product(
      id: '1',
      name: 'Dash Plushie',
      description: 'The iconic Dash plushie, perfect for your desk.',
      price: 19.99,
      imageUrl: 'assets/images/products/dash-plush.png',
      category: 'Toys',
    ),
    quantity: 0,
    onAdd: () {},
    onRemove: () {},
    onTap: () {},
  ),
);

@DashPreview(name: 'Product Card - Keyboard')
Widget productCardKeyboard() => SizedBox(
  width: 200,
  height: 300,
  child: ProductCard(
    product: Product(
      id: '2',
      name: 'Mechanical Keyboard',
      description: 'A high-quality mechanical keyboard for coding.',
      price: 129.99,
      imageUrl: 'assets/images/products/dash-keyboard.png',
      category: 'Gadgets',
    ),
    quantity: 0,
    onAdd: () {},
    onRemove: () {},
    onTap: () {},
  ),
);
