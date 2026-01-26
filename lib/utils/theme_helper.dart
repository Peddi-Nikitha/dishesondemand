import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Helper utility for theme-aware colors
class ThemeHelper {
  ThemeHelper._();

  /// Get background color based on theme
  static Color getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkBackground : AppColors.background;
  }

  /// Get surface color based on theme
  static Color getSurfaceColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkSurface : AppColors.surface;
  }

  /// Get primary text color based on theme
  static Color getTextPrimaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  }

  /// Get secondary text color based on theme
  static Color getTextSecondaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  }

  /// Get border color based on theme
  static Color getBorderColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkBorder : AppColors.border;
  }

  /// Check if current theme is dark
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get primary color based on theme (orange for both themes)
  static Color getPrimaryColor(BuildContext context) {
    // Always return orange for both light and dark themes
    return AppColors.primary;
  }
}

