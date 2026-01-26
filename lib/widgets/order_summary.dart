import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable order summary widget
class OrderSummary extends StatelessWidget {
  final String subTotal;
  final String shipping;
  final String discount;
  final String totalAmount;

  const OrderSummary({
    super.key,
    required this.subTotal,
    required this.shipping,
    required this.discount,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        children: [
          // Sub Total
          _buildSummaryRow('Sub Total:', subTotal),
          const SizedBox(height: AppTheme.spacingM),
          // Shipping
          _buildSummaryRow('Shipping:', shipping),
          const SizedBox(height: AppTheme.spacingM),
          // Discount
          _buildSummaryRow('Discount:', discount),
          const SizedBox(height: AppTheme.spacingM),
          // Dashed Divider
          CustomPaint(
            size: const Size(double.infinity, 1),
            painter: DashedLinePainter(),
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
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                totalAmount,
                style: AppTextStyles.titleMedium.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Builder(
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Note: This needs context, so we'll use a fixed color that works for both themes
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

