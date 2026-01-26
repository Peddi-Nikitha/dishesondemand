import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/theme_helper.dart';

/// Reusable location header widget
class LocationHeader extends StatelessWidget {
  final String location;
  final VoidCallback? onLocationTap;
  final VoidCallback? onNotificationTap;
  final bool hasNotification;

  const LocationHeader({
    super.key,
    required this.location,
    this.onLocationTap,
    this.onNotificationTap,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onLocationTap,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: ThemeHelper.getTextPrimaryColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: ThemeHelper.getTextPrimaryColor(context),
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onNotificationTap,
          child: Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ThemeHelper.getSurfaceColor(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none,
                  color: ThemeHelper.getTextPrimaryColor(context),
                  size: 22,
                ),
              ),
              if (hasNotification)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ThemeHelper.getBackgroundColor(context),
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

