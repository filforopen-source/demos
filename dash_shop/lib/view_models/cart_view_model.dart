import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../repositories/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _cartRepository;

  CartViewModel(this._cartRepository) {
    _cartRepository.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _cartRepository.removeListener(_onCartChanged);
    super.dispose();
  }

  Map<String, CartItem> get items => _cartRepository.items;
  double get subtotal => _cartRepository.subtotal;
  int get itemCount => _cartRepository.itemCount;

  void addToCart(Product product) {
    _cartRepository.addToCart(product);
  }

  void removeFromCart(String productId) {
    _cartRepository.removeFromCart(productId);
  }

  void clear() {
    _cartRepository.clear();
  }
}
