import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Contact information card widget
class ContactInfoCard extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String phoneNumber;
  final VoidCallback? onCallTap;
  final VoidCallback? onChatTap;

  const ContactInfoCard({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.phoneNumber,
    this.onCallTap,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = ThemeHelper.getPrimaryColor(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: ThemeHelper.getBorderColor(context),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Profile picture
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                profileImageUrl,
                width: 56,
                height: 56,
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
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          // Name and phone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phoneNumber,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          GestureDetector(
            onTap: onChatTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                color: AppColors.textOnPrimary,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          GestureDetector(
            onTap: onCallTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone,
                color: AppColors.textOnPrimary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

