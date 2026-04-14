import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/cart_view_model.dart';

class CartScreen extends StatelessWidget {
  final CartViewModel viewModel;

  const CartScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final items = viewModel.items.values.toList();
        final subtotal = viewModel.subtotal;
        final deliveryFee = items.isEmpty ? 0.0 : 3.00;
        final taxes = items.isEmpty ? 0.0 : 2.50;
        final total = subtotal + deliveryFee + taxes;

        return Scaffold(
          backgroundColor: Colors.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isLargeScreen = constraints.maxWidth > 800;

              final cartListWidget = CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 0,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: const EdgeInsetsDirectional.only(
                        start: 24,
                        bottom: 12,
                      ),
                      title: Text(
                        'Cart',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.black,
                        ),
                        onPressed: () => viewModel.clear(),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  if (items.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: isLargeScreen ? 360 + 24 + 24 : 24,
                        top: 16,
                        bottom: 16,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((
                          context,
                          index,
                        ) {
                          if (index.isOdd) {
                            return const SizedBox(height: 24);
                          }
                          final itemIndex = index ~/ 2;
                          final item = items[itemIndex];
                          return Row(
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F4F8),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.asset(
                                    item.product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          item.product.name.contains('Hoodie')
                                              ? Icons.checkroom
                                              : Icons.shopping_bag,
                                          color: Colors.grey.shade400,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: isLargeScreen
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.product.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                '\$${item.product.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.product.category,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 2,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () => viewModel.removeFromCart(
                                                    item.product.id,
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0,
                                                    ),
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () => viewModel.addToCart(
                                                    item.product,
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0,
                                                    ),
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.product.name,
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
                                            item.product.category,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '\$${item.product.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                  vertical: 2,
                                                ),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () => viewModel.removeFromCart(
                                                        item.product.id,
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 4.0,
                                                        ),
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${item.quantity}',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () => viewModel.addToCart(
                                                        item.product,
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 4.0,
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          );
                        }, childCount: items.length * 2 - 1),
                      ),
                    ),
                ],
              );

              Widget? summaryWidget;
              if (items.isNotEmpty) {
                summaryWidget = Container(
                  width: isLargeScreen ? 360 : double.infinity,
                  margin: isLargeScreen 
                      ? const EdgeInsets.only(top: 136, right: 24, bottom: 24) 
                      : null,
                  padding: isLargeScreen 
                      ? const EdgeInsets.all(24) 
                      : const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: isLargeScreen ? BorderRadius.circular(16) : null,
                    border: isLargeScreen 
                        ? Border.all(color: Colors.grey.shade200) 
                        : null,
                    boxShadow: isLargeScreen
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isLargeScreen)
                          const Divider(height: 32, color: Color(0xFFEEEEEE)),
                        _SummaryRow(label: 'Subtotal', value: subtotal),
                        const SizedBox(height: 12),
                        _SummaryRow(label: 'Delivery Fee', value: deliveryFee),
                        const SizedBox(height: 12),
                        _SummaryRow(label: 'Taxes', value: taxes),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            key: const Key('checkoutButton'),
                            onPressed: () => context.push('/checkout'),
                            child: const Text(
                              'Go to checkout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (isLargeScreen) {
                return Stack(
                  children: [
                    cartListWidget,
                    if (summaryWidget != null)
                      Align(
                        alignment: Alignment.topRight,
                        child: summaryWidget,
                      ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cartListWidget),
                  ?summaryWidget,
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
