import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable offer banner widget with carousel support
class OfferBanner extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final String illustrationUrl;
  final int currentIndex;
  final int totalIndicators;
  final VoidCallback? onButtonTap;

  const OfferBanner({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.illustrationUrl,
    this.currentIndex = 0,
    this.totalIndicators = 4,
    this.onButtonTap,
  });

  Widget _buildImage(BuildContext context) {
    // Check if it's a network URL or asset path
    final isNetworkImage = illustrationUrl.startsWith('http://') || 
                           illustrationUrl.startsWith('https://');
    
    if (isNetworkImage) {
      return Image.network(
        illustrationUrl,
        fit: BoxFit.cover,
        headers: const {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.primaryContainer.withValues(alpha: 0.3),
            child: Icon(
              Icons.restaurant_menu,
              size: 80,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: AppColors.primaryContainer.withValues(alpha: 0.3),
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
      );
    } else {
      // Asset image
      return Image.asset(
        illustrationUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.primaryContainer.withValues(alpha: 0.3),
            child: Icon(
              Icons.restaurant_menu,
              size: 80,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            _buildImage(context),
            // Gradient Overlay for better text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        Text(
                          description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        GestureDetector(
                          onTap: onButtonTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingL,
                              vertical: AppTheme.spacingS + 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppTheme.radiusM),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              buttonText,
                              style: AppTextStyles.buttonMedium.copyWith(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carousel indicator widget
class CarouselIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalIndicators;

  const CarouselIndicator({
    super.key,
    required this.currentIndex,
    required this.totalIndicators,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalIndicators,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex
                ? AppColors.primary
                : ThemeHelper.getTextSecondaryColor(context).withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

