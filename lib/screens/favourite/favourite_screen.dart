import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/favourite_product_card.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../cart/shopping_cart_screen.dart';
import '../../models/menu_item.dart';

/// Production-ready favourite screen matching the exact design
class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  // Helper method to get image URL from MenuData
  String _getImageUrl(String itemName) {
    final allItems = MenuData.allItems;
    final item = allItems.firstWhere(
      (item) => item.name == itemName,
      orElse: () => allItems.first,
    );
    return item.imageUrl;
  }

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2x2 Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: AppTheme.spacingM,
                      mainAxisSpacing: AppTheme.spacingM,
                      childAspectRatio: 0.75,
                      children: [
                        FavouriteProductCard(
                          imageUrl: _getImageUrl('Grilled Chicken'),
                          title: 'Grilled Chicken',
                          quantity: '1 serving',
                          currentPrice: '\$18',
                          originalPrice: '\$22',
                          isFavorite: true,
                          onFavoriteTap: () {
                            // Handle unfavorite
                          },
                          onAddTap: () {
                            // Handle add to cart
                          },
                        ),
                        FavouriteProductCard(
                          imageUrl: _getImageUrl('Premium Steak'),
                          title: 'Premium Steak',
                          quantity: '1 serving',
                          currentPrice: '\$32',
                          originalPrice: '\$38',
                          isFavorite: true,
                          onFavoriteTap: () {
                            // Handle unfavorite
                          },
                          onAddTap: () {
                            // Handle add to cart
                          },
                        ),
                        FavouriteProductCard(
                          imageUrl: _getImageUrl('Seafood Platter'),
                          title: 'Seafood Platter',
                          quantity: '1 serving',
                          currentPrice: '\$28',
                          originalPrice: '\$35',
                          isFavorite: true,
                          onFavoriteTap: () {
                            // Handle unfavorite
                          },
                          onAddTap: () {
                            // Handle add to cart
                          },
                        ),
                        FavouriteProductCard(
                          imageUrl: _getImageUrl('Creamy Pasta'),
                          title: 'Creamy Pasta',
                          quantity: '1 serving',
                          currentPrice: '\$15',
                          originalPrice: '\$18',
                          isFavorite: true,
                          onFavoriteTap: () {
                            // Handle unfavorite
                          },
                          onAddTap: () {
                            // Handle add to cart
                          },
                        ),
                        FavouriteProductCard(
                          imageUrl: _getImageUrl('Margherita Pizza'),
                          title: 'Margherita Pizza',
                          quantity: '1 large',
                          currentPrice: '\$20',
                          originalPrice: '\$24',
                          isFavorite: true,
                          onFavoriteTap: () {
                            // Handle unfavorite
                          },
                          onAddTap: () {
                            // Handle add to cart
                          },
                        ),
                        FavouriteProductCard(
                          imageUrl: _getImageUrl('Creamy Soup'),
                          title: 'Creamy Soup',
                          quantity: '1 bowl',
                          currentPrice: '\$10',
                          originalPrice: '\$12',
                          isFavorite: true,
                          onFavoriteTap: () {
                            // Handle unfavorite
                          },
                          onAddTap: () {
                            // Handle add to cart
                          },
                        ),
                      ],
                    ),
                    // Bottom padding
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),
            // Bottom Navigation Bar
            CustomBottomNavBar(
              currentIndex: 2, // Favourite is index 2
              cartItemCount: 3,
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

