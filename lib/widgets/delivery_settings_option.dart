import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Reusable delivery settings option widget with optional toggle
class DeliverySettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool? isToggleOn;
  final ValueChanged<bool>? onToggleChanged;

  const DeliverySettingsOption({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isToggleOn,
    this.onToggleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = ThemeHelper.getPrimaryColor(context);
    final hasToggle = isToggleOn != null;

    return GestureDetector(
      onTap: hasToggle ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        child: Row(
          children: [
            // Icon
            Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacingM),
            // Title
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Toggle or arrow
            if (hasToggle)
              Switch(
                value: isToggleOn!,
                onChanged: onToggleChanged,
                activeThumbColor: primaryColor,
                activeTrackColor: primaryColor.withValues(alpha: 0.5),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                color: primaryColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

