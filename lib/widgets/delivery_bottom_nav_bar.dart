import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/theme_helper.dart';

/// Delivery-specific bottom navigation bar
class DeliveryBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int notificationCount;

  const DeliveryBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = ThemeHelper.getSurfaceColor(context);
    final textSecondaryColor = ThemeHelper.getTextSecondaryColor(context);
    final primaryColor = ThemeHelper.getPrimaryColor(context);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: primaryColor,
        ),
        unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: textSecondaryColor,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: currentIndex == 1 ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                currentIndex == 1 ? Icons.account_balance_wallet : Icons.account_balance_wallet_outlined,
                size: 24,
                color: currentIndex == 1 ? AppColors.textOnPrimary : textSecondaryColor,
              ),
            ),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: currentIndex == 2 ? primaryColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: currentIndex == 2 ? primaryColor : textSecondaryColor,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.local_shipping,
                color: currentIndex == 2 ? AppColors.textOnPrimary : textSecondaryColor,
                size: 24,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(
                  currentIndex == 3 ? Icons.notifications : Icons.notifications_outlined,
                  size: 24,
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationCount > 9 ? '9+' : notificationCount.toString(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textOnPrimary,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 4 ? Icons.person : Icons.person_outline,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

