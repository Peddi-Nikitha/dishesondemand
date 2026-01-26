import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Recent shipment item widget
class RecentShipmentItem extends StatelessWidget {
  final String shipmentId;
  final String origin;
  final String destination;
  final String status; // "Delivered" or "Not Delivered"
  final VoidCallback? onTap;

  const RecentShipmentItem({
    super.key,
    required this.shipmentId,
    required this.origin,
    required this.destination,
    required this.status,
    this.onTap,
  });

  bool get isDelivered => status.toLowerCase().contains('delivered');

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID
            Text(
              'ID: $shipmentId',
              style: AppTextStyles.bodySmall.copyWith(
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            // Route with truck icon
            Row(
              children: [
                Expanded(
                  child: Text(
                    origin,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
                  child: Icon(
                    Icons.local_shipping,
                    color: ThemeHelper.getTextPrimaryColor(context),
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    destination,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                // Status tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: isDelivered
                        ? AppColors.success.withValues(alpha: 0.2)
                        : AppColors.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isDelivered ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
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

