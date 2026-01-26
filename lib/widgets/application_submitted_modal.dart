import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable application submitted confirmation modal
/// Matches the exact design from the screenshot
class ApplicationSubmittedModal extends StatelessWidget {
  final VoidCallback? onGotIt;

  const ApplicationSubmittedModal({
    super.key,
    this.onGotIt,
  });

  static void show(BuildContext context, {VoidCallback? onGotIt}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isDismissible: true,
      enableDrag: true,
      builder: (context) => ApplicationSubmittedModal(onGotIt: onGotIt),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: ThemeHelper.getSurfaceColor(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radiusXL),
              topRight: Radius.circular(AppTheme.radiusXL),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Draggable indicator
              Padding(
                padding: const EdgeInsets.only(top: AppTheme.spacingM),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: AppTheme.spacingL),
                      // Large checkmark icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: ThemeHelper.getPrimaryColor(context),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.textOnPrimary,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXL),
                      // Title
                      Text(
                        'Application Submitted for Verification',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: ThemeHelper.getTextPrimaryColor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      // Description
                      Text(
                        'We will get in touch in 48 Working hours. Be ready to for your ride!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXL),
                    ],
                  ),
                ),
              ),
              // Got it button
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // First pop the modal
                      Navigator.of(context).pop();
                      // Then call the callback which will handle navigation
                      // The callback is passed from the driver requirements screen
                      onGotIt?.call();
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
                      'Got it',
                      style: AppTextStyles.buttonLarge,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

