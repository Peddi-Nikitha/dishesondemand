import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Delivery details card widget
class DeliveryDetailsCard extends StatelessWidget {
  final String trackingId;
  final String receiverName;
  final String pickupAddress;
  final String deliveryAddress;
  final String status;
  final String weight;

  const DeliveryDetailsCard({
    super.key,
    required this.trackingId,
    required this.receiverName,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.status,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: ThemeHelper.getBorderColor(context),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Row 1: Tracking ID and Receiver's Name
          _buildDetailRow(
            context,
            label: 'Tracking ID',
            value: trackingId,
            secondLabel: 'Receivers Name',
            secondValue: receiverName,
          ),
          const Divider(height: AppTheme.spacingXL),
          // Row 2: Pick-up Address and Delivery Address
          _buildDetailRow(
            context,
            label: 'Pick-up Address',
            value: pickupAddress,
            secondLabel: 'Delivery Address',
            secondValue: deliveryAddress,
          ),
          const Divider(height: AppTheme.spacingXL),
          // Row 3: Status and Weight
          _buildDetailRow(
            context,
            label: 'Status',
            value: status,
            secondLabel: 'Weight',
            secondValue: weight,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    required String secondLabel,
    required String secondValue,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(context, label, value),
        ),
        const SizedBox(width: AppTheme.spacingL),
        Expanded(
          child: _buildDetailItem(context, secondLabel, secondValue),
        ),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

