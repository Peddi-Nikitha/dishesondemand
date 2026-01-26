import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Month filter button widget
class MonthFilterButton extends StatelessWidget {
  final String month;
  final bool isSelected;
  final VoidCallback onTap;

  const MonthFilterButton({
    super.key,
    required this.month,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeHelper.getSurfaceColor(context)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: isSelected
              ? Border.all(
                  color: ThemeHelper.getBorderColor(context),
                  width: 1,
                )
              : null,
        ),
        child: Text(
          month,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected
                ? ThemeHelper.getTextPrimaryColor(context)
                : ThemeHelper.getTextSecondaryColor(context),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

