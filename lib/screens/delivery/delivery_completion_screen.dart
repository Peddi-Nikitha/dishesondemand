import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/celebration_graphic.dart';
import '../../widgets/delivery_details_card.dart';
import 'delivery_home_screen.dart';

/// Delivery completion screen shown after successful delivery
class DeliveryCompletionScreen extends StatelessWidget {
  const DeliveryCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                trackingId: 'REG10123637',
                receiverName: 'Mo Tarek',
                pickupAddress: 'Agric, IKD. Lag.',
                deliveryAddress: 'Phase 1. Lekki. Lag.',
                status: 'Transit',
                weight: '4 Kg',
              ),
              const SizedBox(height: AppTheme.spacingXL),
              // Go back Home button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
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
                    'Go back Home',
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

