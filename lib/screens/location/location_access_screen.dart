import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../home/home_screen.dart';

/// Location Access screen with dark theme
class LocationAccessScreen extends StatelessWidget {
  const LocationAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Illustration
              _buildLocationIllustration(),
              const SizedBox(height: AppTheme.spacingXL),
              // Title
              Text(
                'Enable Location Access',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingM),
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                ),
                child: Text(
                  'To ensure a seamless and efficient experience, allow us access to your location.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 3),
              // Allow Location Access Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Request location permission (can be implemented with permission_handler)
                    // For now, just navigate to home
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
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
                    'Allow Location Access',
                    style: AppTextStyles.buttonLarge,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              // Maybe Later Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingM,
                  ),
                ),
                child: Text(
                  'Maybe Later',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationIllustration() {
    return Builder(
      builder: (context) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeHelper.getSurfaceColor(context),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Radar arcs
              CustomPaint(
                size: const Size(200, 200),
                painter: _LocationIllustrationPainter(),
              ),
              // Phone icon in center
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: ThemeHelper.getBackgroundColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
            child: Icon(
              Icons.phone_android,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          // Location pin above phone
          Positioned(
            top: 20,
            child: Icon(
              Icons.location_on,
              size: 32,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

/// Custom painter for location illustration
class _LocationIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw radar arcs
    for (int i = 1; i <= 3; i++) {
      final radius = (size.width / 2) * (i / 3);
      canvas.drawCircle(center, radius, paint);
    }

    // Draw signal waves (cloud-like elements)
    final signalPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    // Draw small cloud-like shapes around the circle
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * math.pi) / 8;
      final x = center.dx + (size.width / 2 - 20) * math.cos(angle);
      final y = center.dy + (size.height / 2 - 20) * math.sin(angle);
      canvas.drawCircle(
        Offset(x, y),
        8,
        signalPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

