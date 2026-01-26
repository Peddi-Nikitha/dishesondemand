import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable theme selector widget
class ThemeSelector extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ThemeSelector({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Row(
        children: [
          // Light Mode
          Expanded(
            child: GestureDetector(
              onTap: () => onThemeChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingM,
                ),
                decoration: BoxDecoration(
                  color: !isDarkMode
                      ? AppColors.primaryContainer.withOpacity(0.35)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.light_mode,
                      color: !isDarkMode
                          ? AppColors.primary
                          : ThemeHelper.getTextSecondaryColor(context),
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      'Light Mode',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: !isDarkMode
                            ? AppColors.primary
                            : ThemeHelper.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Dark Mode
          Expanded(
            child: GestureDetector(
              onTap: () => onThemeChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingM,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.primaryContainer.withOpacity(0.35)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.dark_mode,
                      color: isDarkMode
                          ? AppColors.primary
                          : ThemeHelper.getTextSecondaryColor(context),
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      'Dark Mode',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDarkMode
                            ? AppColors.primary
                            : ThemeHelper.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

