import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Production-ready text styles using Poppins font
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // Font Family
  static String get fontFamily => 'Poppins';

  // Headline Styles
  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.3,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineSmall => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.textPrimary,
        letterSpacing: 0,
      );

  // Title Styles
  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
        letterSpacing: 0,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: AppColors.textPrimary,
        letterSpacing: 0.15,
      );

  static TextStyle get titleSmall => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  // Body Styles
  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: AppColors.textSecondary,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.4,
        color: AppColors.textSecondary,
        letterSpacing: 0.4,
      );

  // Label Styles
  static TextStyle get labelLarge => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  // Button Styles
  static TextStyle get buttonLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonSmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.5,
      );

  // Splash Screen Specific Styles
  static TextStyle get splashHeadline => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.3,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get splashBody => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.6,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      );

  // Highlighted text style (for words like "Vast Grocery")
  static TextStyle get splashHeadlineHighlight => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.3,
        color: AppColors.textHighlight,
        letterSpacing: -0.5,
      );

  // Skip button style
  static TextStyle get skipButton => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AppColors.primary,
        letterSpacing: 0.5,
      );
}

