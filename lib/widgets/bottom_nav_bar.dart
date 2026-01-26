import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/theme_helper.dart';

/// Reusable bottom navigation bar widget
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int cartItemCount;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartItemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = ThemeHelper.getSurfaceColor(context);
    final textSecondaryColor = ThemeHelper.getTextSecondaryColor(context);
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
        selectedItemColor: ThemeHelper.getPrimaryColor(context),
        unselectedItemColor: textSecondaryColor,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: ThemeHelper.getPrimaryColor(context),
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
            icon: Stack(
              children: [
                Icon(
                  currentIndex == 1
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                  size: 24,
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: ThemeHelper.getPrimaryColor(context),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cartItemCount > 9 ? '9+' : cartItemCount.toString(),
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
            label: 'My Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2 ? Icons.favorite : Icons.favorite_border,
              size: 24,
            ),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3 ? Icons.restaurant : Icons.restaurant_outlined,
              size: 24,
            ),
            label: 'My Order',
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

