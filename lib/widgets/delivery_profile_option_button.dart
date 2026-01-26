import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable delivery profile option button widget
class DeliveryProfileOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isPrimary;
  final Widget? trailing;

  const DeliveryProfileOptionButton({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isPrimary = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = ThemeHelper.getPrimaryColor(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: isPrimary
              ? primaryColor
              : primaryColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        child: Row(
          children: [
            // Icon
            Icon(
              icon,
              color: isPrimary
                  ? AppColors.textOnPrimary
                  : primaryColor,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacingM),
            // Title
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: isPrimary
                      ? AppColors.textOnPrimary
                      : ThemeHelper.getTextPrimaryColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Trailing widget or arrow
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  color: isPrimary
                      ? AppColors.textOnPrimary
                      : primaryColor,
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }
}

