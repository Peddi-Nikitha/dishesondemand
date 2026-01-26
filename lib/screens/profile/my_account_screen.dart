import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/account_option_item.dart';
import '../../widgets/settings_option_item.dart';
import '../../widgets/theme_selector.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/logout_dialog.dart';
import '../cart/shopping_cart_screen.dart';
import '../favourite/favourite_screen.dart';
import '../orders/my_orders_screen.dart';
import '../delivery/delivery_welcome_screen.dart';
import '../auth/supermarket_login_screen.dart';

/// Production-ready my account screen matching the exact design
class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  bool _notificationsEnabled = true;

  // Profile image URL
  static const String profileImageUrl =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    ProfileHeader(
                      profileImageUrl: profileImageUrl,
                      name: 'Mohamed Tarek',
                      email: 'foxf.com@gmail.com',
                      onEditTap: () {
                        // Handle edit profile
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    // Account Options
                    AccountOptionItem(
                      icon: Icons.shopping_cart,
                      title: 'My Orders',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyOrdersScreen(),
                          ),
                        );
                      },
                    ),
                    AccountOptionItem(
                      icon: Icons.favorite_border,
                      title: 'My Wishlist',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FavouriteScreen(),
                          ),
                        );
                      },
                    ),
                    AccountOptionItem(
                      icon: Icons.credit_card,
                      title: 'Payment Method',
                      onTap: () {
                        // Handle payment method
                      },
                    ),
                    AccountOptionItem(
                      icon: Icons.local_shipping,
                      title: 'Delivery account',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DeliveryWelcomeScreen(),
                          ),
                        );
                      },
                    ),
                    AccountOptionItem(
                      icon: Icons.point_of_sale,
                      title: 'Supermarket Dashboard (POS System)',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SupermarketLoginScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    // Settings Section
                    Text(
                      'Settings',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    SettingsOptionItem(
                      icon: Icons.lock,
                      title: 'Password Manager',
                      onTap: () {
                        // Handle password manager
                      },
                    ),
                    SettingsOptionItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      isToggleOn: _notificationsEnabled,
                      onToggleChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    SettingsOptionItem(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () {
                        // Handle help center
                      },
                    ),
                    SettingsOptionItem(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      onTap: () {
                        // Handle privacy policy
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    // Theme Selector
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) {
                        return ThemeSelector(
                          isDarkMode: themeProvider.isDarkMode,
                          onThemeChanged: (isDark) {
                            themeProvider.setThemeMode(
                              isDark ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    // Log Out Button
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withValues(alpha: 0.5),
                          barrierDismissible: true,
                          builder: (context) => const LogoutDialog(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(AppTheme.radiusL),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                              ),
                              child: Icon(
                                Icons.logout,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingM),
                            Expanded(
                              child: Text(
                                'Log out',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),
            // Bottom Navigation Bar
            CustomBottomNavBar(
              currentIndex: 4, // Profile is index 4
              cartItemCount: 3,
              onTap: (index) {
                if (index == 0) {
                  // Navigate to Home
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else if (index == 1) {
                  // Navigate to Cart
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ShoppingCartScreen(),
                    ),
                  );
                } else if (index == 2) {
                  // Navigate to Favourite
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FavouriteScreen(),
                    ),
                  );
                } else if (index == 3) {
                  // Navigate to My Orders
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyOrdersScreen(),
                    ),
                  );
                } else if (index == 4) {
                  // Already on Profile screen - do nothing
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ThemeHelper.getBackgroundColor(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: ThemeHelper.getTextPrimaryColor(context),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            // Title
            Text(
              'My Account',
              style: AppTextStyles.titleLarge.copyWith(
                color: ThemeHelper.getTextPrimaryColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

