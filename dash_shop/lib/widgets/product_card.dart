import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.quantity = 0,
    required this.onAdd,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey('product_card_${product.id}'),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFF1F4F8,
                ), // light gray from original code works well
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            product.name.contains('Keyboard')
                                ? Icons.keyboard
                                : product.name.contains('Plushie')
                                ? Icons.toys
                                : product.name.contains('Hoodie')
                                ? Icons.checkroom
                                : Icons.shopping_bag,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: _buildQuantityControl(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControl() {
    if (quantity == 0) {
      return Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          key: ValueKey('product_add_${product.id}'),
          onTap: onAdd,
          customBorder: const CircleBorder(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.add, size: 24, color: Colors.black),
          ),
        ),
      );
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            key: ValueKey('product_remove_${product.id}'),
            onTap: onRemove,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 8, 8),
              child: Icon(Icons.remove, size: 20, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '$quantity',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          InkWell(
            key: ValueKey('product_add_${product.id}'),
            onTap: onAdd,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 12, 8),
              child: Icon(Icons.add, size: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
