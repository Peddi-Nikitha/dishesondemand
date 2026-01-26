import 'package:flutter/material.dart';

/// Production-ready color system for the restaurant app
/// Based on orange primary color
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors - Orange theme
  static const Color primary = Color(0xFFFF5B05); // Orange
  static const Color primaryLight = Color(0xFFFF7A2E); // Lighter orange
  static const Color primaryDark = Color(0xFFE64A00); // Darker orange
  static const Color primaryContainer = Color(0xFFFFE8D6); // Light orange tint

  // Secondary Colors
  static const Color secondary = Color(0xFFFF5B05); // Orange (same as primary)
  static const Color secondaryLight = Color(0xFFFF7A2E);
  static const Color secondaryDark = Color(0xFFE64A00);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Dark grey
  static const Color textSecondary = Color(0xFF757575); // Medium grey
  static const Color textTertiary = Color(0xFF9E9E9E); // Light grey
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White on orange
  static const Color textHighlight = Color(0xFFFF5B05); // Orange for highlights

  // Background Colors
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color backgroundSecondary = Color(0xFFF5F5F5); // Light grey
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50); // Keep green for success
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // UI Element Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000); // 10% opacity black

  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryHover = primaryDark;
  static const Color buttonSecondary = Color(0xFFF5F5F5);
  static const Color buttonText = textPrimary;

  // Icon Colors
  static const Color iconPrimary = primary; // Orange for primary icons
  static const Color iconSecondary = textSecondary;
  static const Color iconOnPrimary = textOnPrimary;

  // Page Indicator Colors
  static const Color indicatorActive = primary;
  static const Color indicatorInactive = Color(0xFFE0E0E0);

  // Restaurant Theme Specific
  static const Color restaurantAccent = Color(0xFFFF7A2E); // Light orange accent
  static const Color restaurantBackground = Color(0xFFFAFAFA); // Off-white background

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1A1A1A); // Dark grey/black
  static const Color darkSurface = Color(0xFF2A2A2A); // Dark surface
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // White text
  static const Color darkTextSecondary = Color(0xFFB0B0B0); // Light grey text
  static const Color darkBorder = Color(0xFF3A3A3A); // Dark border
  static const Color darkDivider = Color(0xFF3A3A3A); // Dark divider
  static const Color darkPrimary = Color(0xFFFF5B05); // Orange (same as primary)
}

