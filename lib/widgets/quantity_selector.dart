import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/theme_helper.dart';

/// Reusable quantity selector widget with +/- buttons
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final String quantityText;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.quantityText,
    this.onDecrease,
    this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Minus Button
        GestureDetector(
          onTap: onDecrease,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: ThemeHelper.getBackgroundColor(context),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove,
              color: ThemeHelper.getTextPrimaryColor(context),
              size: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Quantity Text
        Text(
          quantityText,
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        // Plus Button
        GestureDetector(
          onTap: onIncrease,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.textOnPrimary,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}

