import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable search bar widget
class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final VoidCallback? onSettingsTap;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search Food, Drinks, etc',
    this.onTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingM,
              ),
              decoration: BoxDecoration(
                color: ThemeHelper.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    hintText,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingS),
        GestureDetector(
          onTap: onSettingsTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ThemeHelper.getSurfaceColor(context),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
            ),
            child: Icon(
              Icons.settings,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

