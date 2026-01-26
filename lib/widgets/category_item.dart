import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/theme_helper.dart';

/// Reusable category item widget for category section
class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.imageUrl,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: ThemeHelper.getSurfaceColor(context),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                headers: const {
                  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                  'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                },
                cacheWidth: 144,
                cacheHeight: 144,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ThemeHelper.getSurfaceColor(context),
                    child: Icon(
                      Icons.image_not_supported,
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: ThemeHelper.getPrimaryColor(context),
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

