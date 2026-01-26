import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import '../utils/theme_helper.dart';

/// Theme toggle selector widget (Light/Dark Mode)
class ThemeToggleSelector extends StatelessWidget {
  const ThemeToggleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDarkMode = themeProvider.isDarkMode;
        
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: ThemeHelper.getSurfaceColor(context),
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(
              color: ThemeHelper.getBorderColor(context),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Light Mode button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    themeProvider.setThemeMode(ThemeMode.light);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingM,
                    ),
                    decoration: BoxDecoration(
                      color: !isDarkMode
                          ? ThemeHelper.getPrimaryColor(context)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.light_mode,
                          color: !isDarkMode
                              ? AppColors.textOnPrimary
                              : ThemeHelper.getTextSecondaryColor(context),
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Text(
                          'Light Mode',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: !isDarkMode
                                ? AppColors.textOnPrimary
                                : ThemeHelper.getTextSecondaryColor(context),
                            fontWeight: !isDarkMode
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Dark Mode button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    themeProvider.setThemeMode(ThemeMode.dark);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingM,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? ThemeHelper.getPrimaryColor(context)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dark_mode,
                          color: isDarkMode
                              ? AppColors.textOnPrimary
                              : ThemeHelper.getTextSecondaryColor(context),
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Text(
                          'Dark Mode',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isDarkMode
                                ? AppColors.textOnPrimary
                                : ThemeHelper.getTextSecondaryColor(context),
                            fontWeight: isDarkMode
                                ? FontWeight.w600
                                : FontWeight.normal,
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
      },
    );
  }
}

