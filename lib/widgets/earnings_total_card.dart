import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Total earnings card widget
class EarningsTotalCard extends StatelessWidget {
  final String label;
  final String amount;
  final String changeText;
  final bool isPositive;

  const EarningsTotalCard({
    super.key,
    required this.label,
    required this.amount,
    required this.changeText,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(
          color: ThemeHelper.getBorderColor(context),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            amount,
            style: AppTextStyles.headlineMedium.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: ThemeHelper.getPrimaryColor(context),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                changeText,
                style: AppTextStyles.bodySmall.copyWith(
                  color: ThemeHelper.getPrimaryColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

