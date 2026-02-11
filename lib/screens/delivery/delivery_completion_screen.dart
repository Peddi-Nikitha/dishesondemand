import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../utils/constants.dart';
import '../../widgets/celebration_graphic.dart';
import '../../widgets/delivery_details_card.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import 'delivery_home_screen.dart';

/// Delivery completion screen shown after successful delivery
/// Now displays real order data from Firestore
class DeliveryCompletionScreen extends StatelessWidget {
  final OrderModel order;

  const DeliveryCompletionScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    String _formatAddress() {
      final addr = order.deliveryAddress;
      return '${addr.street}, ${addr.city}, ${addr.state}, ${addr.zipCode}';
    }

    String _statusLabel(String status) {
      switch (status) {
        case AppConstants.orderStatusPending:
          return 'Pending';
        case AppConstants.orderStatusConfirmed:
          return 'Confirmed';
        case AppConstants.orderStatusPreparing:
          return 'Preparing';
        case AppConstants.orderStatusReady:
          return 'Ready';
        case AppConstants.orderStatusAssigned:
          return 'Assigned';
        case AppConstants.orderStatusPickedUp:
          return 'Picked Up';
        case AppConstants.orderStatusInTransit:
          return 'In Transit';
        case AppConstants.orderStatusDelivered:
          return 'Delivered';
        case AppConstants.orderStatusCancelled:
          return 'Cancelled';
        default:
          return status;
      }
    }

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppTheme.spacingXL),
              // Celebratory graphic
              const SizedBox(
                width: 200,
                height: 200,
                child: CelebrationGraphic(),
              ),
              const SizedBox(height: AppTheme.spacingXL),
              // Awesome title
              Text(
                'Awesome!',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              // Confirmation text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                child: Text(
                  'You have completed the package delivery of the parcel with the information below',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),
              // Delivery details card
              DeliveryDetailsCard(
                trackingId: order.orderNumber,
                receiverName: 'Customer', // Could be enhanced with user data
                pickupAddress: 'Restaurant', // Placeholder until restaurant address is stored
                deliveryAddress: _formatAddress(),
                status: _statusLabel(order.status),
                weight: '${order.items.length} items',
              ),
              const SizedBox(height: AppTheme.spacingXL),
              // Mark as done button (marks order as delivered and returns home)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    final orderProvider =
                        Provider.of<OrderProvider>(context, listen: false);

                    // If not already delivered, update status
                    if (order.status != AppConstants.orderStatusDelivered) {
                      final success = await orderProvider.updateOrderStatus(
                        order.id,
                        AppConstants.orderStatusDelivered,
                      );

                      if (!context.mounted) return;

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              orderProvider.error ??
                                  'Failed to update order status',
                            ),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }
                    }

                    if (!context.mounted) return;

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const DeliveryHomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeHelper.getPrimaryColor(context),
                    foregroundColor: AppColors.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Mark as done',
                    style: AppTextStyles.buttonLarge,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              // Report Issue link
              TextButton(
                onPressed: () {
                  // Handle report issue
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingM,
                  ),
                ),
                child: Text(
                  'Report Issue',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}

