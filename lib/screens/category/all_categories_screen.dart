import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../models/product_model.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/category_item.dart';
import '../category/category_detail_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  // Get category image URL (fallback to default if not provided)
  String _getCategoryImageUrl(CategoryModel category) {
    if (category.imageUrl != null && category.imageUrl!.isNotEmpty) {
      return category.imageUrl!;
    }
    // Default images based on category name
    final categoryName = category.name.toLowerCase();
    
    // Starters/Appetizers
    if (categoryName.contains('starter') || categoryName.contains('appetizer')) {
      return 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=200&h=200&fit=crop';
    }
    // Breakfast
    else if (categoryName.contains('breakfast') || categoryName.contains('morning')) {
      return 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=200&h=200&fit=crop';
    }
    // Lunch
    else if (categoryName.contains('lunch') || categoryName.contains('midday')) {
      return 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=200&h=200&fit=crop';
    }
    // Supper/Dinner
    else if (categoryName.contains('supp') || categoryName.contains('supper') || 
             categoryName.contains('dinner') || categoryName.contains('evening')) {
      return 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200&h=200&fit=crop';
    }
    // Desserts
    else if (categoryName.contains('dessert') || categoryName.contains('sweet')) {
      return 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=200&h=200&fit=crop';
    }
    // Beverages/Drinks
    else if (categoryName.contains('bev') || categoryName.contains('beverage') || 
             categoryName.contains('drink') || categoryName.contains('beverages')) {
      return 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=200&h=200&fit=crop';
    }
    // Main Course
    else if (categoryName.contains('main') || categoryName.contains('course')) {
      return 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200&h=200&fit=crop';
    }
    // Salads
    else if (categoryName.contains('salad')) {
      return 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=200&h=200&fit=crop';
    }
    // Vegetarian
    else if (categoryName.contains('veg') && !categoryName.contains('non')) {
      return 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=200&h=200&fit=crop';
    }
    // Non-Vegetarian/Meat
    else if (categoryName.contains('non') || categoryName.contains('meat')) {
      return 'https://images.unsplash.com/photo-1532550907401-a78c000e25fb?w=200&h=200&fit=crop';
    }
    // Default fallback
    return 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200&h=200&fit=crop';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        foregroundColor: ThemeHelper.getTextPrimaryColor(context),
        elevation: 0,
      ),
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, _) {
          final categories = categoryProvider.categories
              .where((c) => c.isActive)
              .toList()
            ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

          if (categories.isEmpty) {
            return Center(
              child: Text(
                'No categories available',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: ThemeHelper.getTextSecondaryColor(context),
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: AppTheme.spacingM,
              crossAxisSpacing: AppTheme.spacingM,
              childAspectRatio: 0.8,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryItem(
                imageUrl: _getCategoryImageUrl(category),
                label: category.name,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CategoryDetailScreen(
                        categoryName: category.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}


