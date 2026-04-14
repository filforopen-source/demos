import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dash_shop/view_models/cart_view_model.dart';
import 'package:dash_shop/repositories/cart_repository.dart';
import 'package:dash_shop/models/product.dart';

void main() {
  group('CartViewModel', () {
    final product = Product(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 10.0,
      imageUrl: 'test.png',
      category: 'Test Category',
    );

    test('clear() removes all items from the cart', () {
      final viewModel = CartViewModel(CartRepository());
      viewModel.addToCart(product);
      check(viewModel.itemCount).equals(1);

      viewModel.clear();
      check(viewModel.itemCount).equals(0);
      check(viewModel.items).isEmpty();
    });
  });
}
