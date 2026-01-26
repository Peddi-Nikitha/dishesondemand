import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/grid_product_card.dart';
import '../../models/menu_item.dart';
import '../product/product_detail_screen.dart';

/// Category detail screen showing all items in a specific category
/// Matches the exact design from the screenshot with 2-column grid layout
class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;

  const CategoryDetailScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final Map<String, bool> _favorites = {};

  List<MenuItem> get _items => MenuData.getItemsByCategory(widget.categoryName);

  bool _isFavorite(String itemId) => _favorites[itemId] ?? false;

  void _toggleFavorite(String itemId) {
    setState(() {
      _favorites[itemId] = !(_favorites[itemId] ?? false);
    });
  }

  void _onAddToCart(MenuItem item) {
    // Handle add to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _onItemTap(MenuItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          productName: item.name,
          category: item.category,
          imageUrl: item.imageUrl,
          price: item.formattedCurrentPrice,
          rating: item.rating,
          quantity: item.quantity,
          description: item.description,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              child: Row(
                children: [
                  // Back button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.arrow_left,
                          color: ThemeHelper.getTextPrimaryColor(context),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  Expanded(
                    child: Text(
                      widget.categoryName,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            // Product grid
            Expanded(
              child: _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 64,
                            color: ThemeHelper.getTextSecondaryColor(context),
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          Text(
                            'No items found',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: ThemeHelper.getTextSecondaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: AppTheme.spacingM,
                        mainAxisSpacing: AppTheme.spacingM,
                      ),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return GridProductCard(
                          imageUrl: item.imageUrl,
                          title: item.name,
                          quantity: item.quantity,
                          currentPrice: item.formattedCurrentPrice,
                          originalPrice: item.originalPrice != null
                              ? item.formattedOriginalPrice
                              : null,
                          isFavorite: _isFavorite(item.id),
                          onFavoriteTap: () => _toggleFavorite(item.id),
                          onAddTap: () => _onAddToCart(item),
                          onTap: () => _onItemTap(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

