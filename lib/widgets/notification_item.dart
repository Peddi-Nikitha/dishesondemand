import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable notification item widget
class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String timeAgo;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.timeAgo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Icon(
                icon,
                color: ThemeHelper.getPrimaryColor(context),
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and time
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: ThemeHelper.getTextPrimaryColor(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  // Description
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

