import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/driver_requirement_item.dart';
import '../../widgets/application_submitted_modal.dart';
import 'delivery_home_screen.dart';

/// Driver Requirements screen matching the exact design from screenshot
class DriverRequirementsScreen extends StatelessWidget {
  const DriverRequirementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Driver Requirements',
          style: AppTextStyles.titleLarge.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Text(
                'Welcome!, Esther',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Required Steps section
                    Text(
                      'Required Steps',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    // Profile Picture
                    DriverRequirementItem(
                      title: 'Profile Picture',
                      isCompleted: false,
                      onTap: () {
                        // Handle profile picture tap
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    // Bank Account Details
                    DriverRequirementItem(
                      title: 'Bank Account Details',
                      isCompleted: false,
                      onTap: () {
                        // Handle bank account details tap
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    // Driving Details
                    DriverRequirementItem(
                      title: 'Driving Details',
                      isCompleted: false,
                      onTap: () {
                        // Handle driving details tap
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Submitted Steps section
                    Text(
                      'Submitted Steps',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    // Government ID
                    DriverRequirementItem(
                      title: 'Government ID',
                      isCompleted: true,
                      onTap: () {
                        // Handle government ID tap
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    // Car Information
                    DriverRequirementItem(
                      title: 'Car Information',
                      isCompleted: true,
                      onTap: () {
                        // Handle car information tap
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),
            // Done button at bottom
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Show application submitted modal
                    ApplicationSubmittedModal.show(
                      context,
                      onGotIt: () {
                        // Navigate to delivery home screen after user acknowledges
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const DeliveryHomeScreen(),
                          ),
                        );
                      },
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
                    'Done',
                    style: AppTextStyles.buttonLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

