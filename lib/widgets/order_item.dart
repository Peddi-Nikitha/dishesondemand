import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable order item widget for displaying items in an order
class OrderItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String quantity;
  final String currentPrice;
  final String originalPrice;
  final String discountBadge;

  const OrderItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.quantity,
    required this.currentPrice,
    required this.originalPrice,
    required this.discountBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Badge
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                  decoration: BoxDecoration(
                    color: ThemeHelper.isDarkMode(context)
                        ? AppColors.primaryContainer.withValues(alpha: 0.15)
                        : AppColors.primaryContainer.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    headers: const {
                      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                      'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                    },
                    cacheWidth: 160,
                    cacheHeight: 160,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: ThemeHelper.getSurfaceColor(context),
                        child: Icon(
                          Icons.image_not_supported,
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 80,
                        height: 80,
                        color: ThemeHelper.getSurfaceColor(context),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: ThemeHelper.getPrimaryColor(context),
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Discount Badge
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.radiusM),
                      bottomRight: Radius.circular(AppTheme.radiusM),
                    ),
                  ),
                  child: Text(
                    discountBadge,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textOnPrimary,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppTheme.spacingM),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quantity,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: ThemeHelper.getTextSecondaryColor(context),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      currentPrice,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      originalPrice,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: ThemeHelper.getTextSecondaryColor(context),
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

