import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../view_models/cart_view_model.dart';

class CartFab extends StatelessWidget {
  final CartViewModel viewModel;

  const CartFab({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final hasItems = viewModel.itemCount > 0;
        final subtotalText = '\$${viewModel.subtotal.toStringAsFixed(2)}';

        return Material(
          color: Colors.black,
          borderRadius: BorderRadius.circular(28),
          elevation: 6,
          child: InkWell(
            key: const ValueKey('cart_fab'),
            borderRadius: BorderRadius.circular(28),
            onTap: () => context.go('/cart'),
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: hasItems
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                subtotalText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
