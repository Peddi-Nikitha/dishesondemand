import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Earnings shipment item widget
class EarningsShipmentItem extends StatelessWidget {
  final String label;
  final String origin;
  final String destination;
  final String amount;
  final String status;
  final VoidCallback? onTap;

  const EarningsShipmentItem({
    super.key,
    required this.label,
    required this.origin,
    required this.destination,
    required this.amount,
    required this.status,
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
          color: ThemeHelper.getSurfaceColor(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(
            color: ThemeHelper.getBorderColor(context),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Left side - Label and route
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Row(
                    children: [
                      Text(
                        origin,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: ThemeHelper.getTextPrimaryColor(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
                        child: Icon(
                          Icons.local_shipping,
                          color: ThemeHelper.getTextPrimaryColor(context),
                          size: 16,
                        ),
                      ),
                      Text(
                        destination,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right side - Amount and status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

