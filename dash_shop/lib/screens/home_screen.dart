import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../view_models/cart_view_model.dart';
import '../view_models/catalog_view_model.dart';
import '../widgets/product_card.dart';

import 'package:google_fonts/google_fonts.dart';

import '../widgets/cart_fab.dart';

class HomeScreen extends StatelessWidget {
  final CatalogViewModel catalogViewModel;
  final CartViewModel cartViewModel;

  const HomeScreen({
    super.key,
    required this.catalogViewModel,
    required this.cartViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: CartFab(viewModel: cartViewModel),
      body: ListenableBuilder(
        listenable: Listenable.merge([catalogViewModel, cartViewModel]),
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0,
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsetsDirectional.only(
                    start: 16,
                    bottom: 12,
                  ),
                  title: Text(
                    'Dash Shop',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      letterSpacing: -0.5,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Featured Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              'assets/images/products/dash-keyboard.png',
                              width: 140,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.phone_iphone,
                                    size: 120,
                                    color: Colors.grey.shade400,
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'New Merch!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context.go('/shop'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(120, 36),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                ),
                                child: const Text('Shop Now'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Trending Now Title
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: Text(
                    'Trending Now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              if (catalogViewModel.products.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = catalogViewModel
                            .products[index % catalogViewModel.products.length];
                        final cartItem = cartViewModel.items[product.id];
                        final quantity = cartItem?.quantity ?? 0;
                        return ProductCard(
                          product: product,
                          quantity: quantity,
                          onAdd: () {
                            cartViewModel.addToCart(product);
                          },
                          onRemove: () {
                            cartViewModel.removeFromCart(product.id);
                          },
                          onTap: () =>
                              context.push('/shop/product/${product.id}'),
                        );
                      },
                      childCount: 4,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}
