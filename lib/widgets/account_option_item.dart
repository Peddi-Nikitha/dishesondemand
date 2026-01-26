import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable account option item widget
class AccountOptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const AccountOptionItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: ThemeHelper.isDarkMode(context)
              ? AppColors.primaryContainer.withValues(alpha: 0.15)
              : AppColors.primaryContainer.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Icon(
                icon,
                color: ThemeHelper.getPrimaryColor(context),
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            // Title
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: ThemeHelper.getPrimaryColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

