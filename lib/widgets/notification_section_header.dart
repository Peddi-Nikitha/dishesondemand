import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Notification section header widget with "Mark all as read" action
class NotificationSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMarkAllAsRead;

  const NotificationSectionHeader({
    super.key,
    required this.title,
    this.onMarkAllAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
        vertical: AppTheme.spacingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: onMarkAllAsRead,
            child: Text(
              'Mark all as read',
              style: AppTextStyles.bodyMedium.copyWith(
                color: ThemeHelper.getPrimaryColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

