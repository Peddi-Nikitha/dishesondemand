import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Location permission dialog matching the design
class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onMaybeLater;

  const LocationPermissionDialog({
    super.key,
    required this.onAllow,
    required this.onMaybeLater,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppTheme.spacingM),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        decoration: BoxDecoration(
          color: ThemeHelper.getBackgroundColor(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Location Icon Graphic
            _buildLocationIcon(context),
            const SizedBox(height: AppTheme.spacingXL),
            // Title
            Text(
              'Enable Location Access',
              style: AppTextStyles.titleLarge.copyWith(
                color: ThemeHelper.getTextPrimaryColor(context),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingM),
            // Description
            Text(
              'To ensure a seamless and efficient experience, allow us access to your location.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingXL),
            // Allow Location Access Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onAllow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Allow Location Access',
                  style: AppTextStyles.buttonLarge.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            // Maybe Later Link
            TextButton(
              onPressed: onMaybeLater,
              child: Text(
                'Maybe Later',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationIcon(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring with dots
          CustomPaint(
            size: const Size(200, 200),
            painter: _LocationRingPainter(),
          ),
          // Middle ring
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
          // Inner square with phone icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: ThemeHelper.isDarkMode(context)
                  ? AppColors.darkSurface
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.smartphone,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          // Location pin icon above
          Positioned(
            top: 20,
            child: Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the outer ring with dots
class _LocationRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw outer ring
    canvas.drawCircle(center, radius, paint);

    // Draw dots around the ring
    final dotPaint = Paint()
      ..color = AppColors.primaryDark
      ..style = PaintingStyle.fill;

    const dotCount = 8;
    const dotRadius = 4.0;

    for (int i = 0; i < dotCount; i++) {
      final angle = (i * 2 * math.pi) / dotCount;
      final dotX = center.dx + (radius * 1.1) * math.cos(angle);
      final dotY = center.dy + (radius * 1.1) * math.sin(angle);
      canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

