import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/favourite_product_card.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../cart/shopping_cart_screen.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';

/// Production-ready favourite screen with Firestore integration
class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Main Content - Product Grid
            Expanded(
              child: Consumer3<AuthProvider, ProductProvider, CartProvider>(
                builder: (context, authProvider, productProvider, cartProvider, child) {
                  // Get favorite product IDs from auth provider
                  final favoriteIds = authProvider.favorites;
                  
                  if (favoriteIds.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 80,
                            color: ThemeHelper.getTextSecondaryColor(context),
                          ),
                          const SizedBox(height: AppTheme.spacingL),
                          Text(
                            'No favorites yet',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            'Add products to your favorites',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: ThemeHelper.getTextSecondaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Get products that are in favorites
                  final favoriteProducts = productProvider.products
                      .where((product) => favoriteIds.contains(product.id))
                      .toList();

                  if (favoriteProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 80,
                            color: ThemeHelper.getTextSecondaryColor(context),
                          ),
                          const SizedBox(height: AppTheme.spacingL),
                          Text(
                            'Loading favorites...',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2x2 Grid
                        GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: AppTheme.spacingM,
                            mainAxisSpacing: AppTheme.spacingM,
                            childAspectRatio: 0.75,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: favoriteProducts.length,
                          itemBuilder: (context, index) {
                            final product = favoriteProducts[index];

                            return FavouriteProductCard(
                              imageUrl: product.imageUrl,
                              title: product.name,
                              quantity: product.quantity,
                              currentPrice: product.formattedCurrentPrice,
                              originalPrice: product.formattedOriginalPrice,
                              isFavorite: true,
                              onFavoriteTap: () async {
                                final success = await authProvider.removeFavorite(product.id);
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product.name} removed from favorites'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                              onAddTap: () {
                                cartProvider.addItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: Colors.white),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            '${product.name} added to cart',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: AppColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.only(
                                      bottom: 80,
                                      left: 16,
                                      right: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 6,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        // Bottom padding
                        const SizedBox(height: AppTheme.spacingXL),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Navigation Bar
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return CustomBottomNavBar(
                  currentIndex: 2, // Favourite is index 2
                  cartItemCount: cartProvider.itemCount,
                  onTap: (index) {
                    if (index == 0) {
                      // Navigate to Home
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    } else if (index == 1) {
                      // Navigate to Cart
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ShoppingCartScreen(),
                        ),
                      );
                    } else if (index == 2) {
                      // Already on Favourite screen - do nothing
                    } else {
                      // Handle other navigation items
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getBackgroundColor(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: ThemeHelper.getTextPrimaryColor(context),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          // Title
          Expanded(
            child: Text(
              'Favourite',
              style: AppTextStyles.titleLarge.copyWith(
                color: ThemeHelper.getTextPrimaryColor(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
