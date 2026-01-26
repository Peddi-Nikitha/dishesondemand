import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';
import 'order_item.dart';

/// Reusable order card widget
class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String shoppingCartNumber;
  final String orderDate;
  final List<OrderItemData> items;
  final String totalAmount;
  final String? orderStatus; // 'active', 'completed', 'canceled'
  final VoidCallback? onTrackOrder;
  final VoidCallback? onCancel;
  final VoidCallback? onReorder;
  final VoidCallback? onRate;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.shoppingCartNumber,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    this.orderStatus,
    this.onTrackOrder,
    this.onCancel,
    this.onReorder,
    this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = orderStatus == 'completed';
    final isCanceled = orderStatus == 'canceled';
    final borderColor = isCanceled
        ? AppColors.error
        : (isCompleted ? AppColors.success : AppColors.primary);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Order No: ',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: orderNumber,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Shopping cart # $shoppingCartNumber',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                orderDate,
                style: AppTextStyles.bodySmall.copyWith(
                  color: ThemeHelper.getTextSecondaryColor(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Order Items
          ...items.map((item) => OrderItem(
                imageUrl: item.imageUrl,
                title: item.title,
                quantity: item.quantity,
                currentPrice: item.currentPrice,
                originalPrice: item.originalPrice,
                discountBadge: item.discountBadge,
              )),
          const SizedBox(height: AppTheme.spacingM),
          // Action Buttons
          if (isCompleted || isCanceled)
            // Re-order and Rate buttons for completed/canceled orders
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReorder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Re-order',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: AppColors.textOnPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeHelper.getSurfaceColor(context),
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        side: BorderSide(
                          color: ThemeHelper.getBorderColor(context),
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Rate',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            // Track Order and Cancel buttons for active orders
            Row(
              children: [
                Text(
                  'Track order:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTrackOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Track Order',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: AppColors.textOnPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: AppColors.textOnPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppTheme.spacingM),
          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount:',
                style: AppTextStyles.titleMedium.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
              Text(
                totalAmount,
                style: AppTextStyles.titleMedium.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Data class for order items
class OrderItemData {
  final String imageUrl;
  final String title;
  final String quantity;
  final String currentPrice;
  final String originalPrice;
  final String discountBadge;

  OrderItemData({
    required this.imageUrl,
    required this.title,
    required this.quantity,
    required this.currentPrice,
    required this.originalPrice,
    required this.discountBadge,
  });
}

