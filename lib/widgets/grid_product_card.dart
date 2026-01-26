import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable grid product card widget matching the screenshot design
/// Used in category detail screens with 2-column grid layout
class GridProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String quantity;
  final String currentPrice;
  final String? originalPrice;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onTap;

  const GridProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.quantity,
    required this.currentPrice,
    this.originalPrice,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onAddTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        splashColor: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1),
        highlightColor: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: ThemeHelper.getSurfaceColor(context),
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder
                  : AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with favorite icon
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.radiusL),
                      topRight: Radius.circular(AppTheme.radiusL),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      color: isDark 
                          ? AppColors.darkSurface 
                          : const Color(0xFFE8F5E9), // Light mint green background like screenshot
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                        headers: const {
                          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                          'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                        },
                        cacheWidth: 400,
                        cacheHeight: 400,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 140,
                            color: ThemeHelper.getSurfaceColor(context),
                            child: Icon(
                              Icons.restaurant_menu,
                              size: 50,
                              color: ThemeHelper.getTextSecondaryColor(context),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: 140,
                            color: ThemeHelper.getSurfaceColor(context),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Favorite icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onFavoriteTap,
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: ThemeHelper.getBackgroundColor(context).withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFavorite
                                ? AppColors.primary
                                : ThemeHelper.getTextPrimaryColor(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Product details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        title,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: ThemeHelper.getTextPrimaryColor(context),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Quantity
                      Text(
                        quantity,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: ThemeHelper.getTextSecondaryColor(context),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      // Price and Add button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Price column
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Current price
                                Text(
                                  currentPrice,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                // Original price (if exists)
                                if (originalPrice != null && originalPrice!.isNotEmpty)
                                  Text(
                                    originalPrice!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: ThemeHelper.getTextSecondaryColor(context),
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Add button
                          GestureDetector(
                            onTap: onAddTap,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                              ),
                              child: Text(
                                'Add',
                                style: AppTextStyles.buttonSmall.copyWith(
                                  color: AppColors.textOnPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

