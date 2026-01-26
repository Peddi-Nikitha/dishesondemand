import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Delivery profile header widget with profile picture, name, and email
class DeliveryProfileHeader extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String email;
  final VoidCallback? onEditTap;

  const DeliveryProfileHeader({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.email,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(
          color: ThemeHelper.getBorderColor(context),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Profile content
          Column(
            children: [
              const SizedBox(height: AppTheme.spacingM),
              // Profile picture
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ThemeHelper.getPrimaryColor(context),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    profileImageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    headers: const {
                      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: ThemeHelper.getSurfaceColor(context),
                        child: Icon(
                          Icons.person,
                          color: ThemeHelper.getTextSecondaryColor(context),
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              // Name
              Text(
                name,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              // Email
              Text(
                email,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: ThemeHelper.getTextSecondaryColor(context),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
            ],
          ),
          // Edit button
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ThemeHelper.getPrimaryColor(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  color: AppColors.textOnPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

