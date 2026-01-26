import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/delivery_profile_header.dart';
import '../../widgets/delivery_profile_option_button.dart';
import '../../widgets/delivery_settings_option.dart';
import '../../widgets/delivery_bottom_nav_bar.dart';
import '../../widgets/theme_toggle_selector.dart';
import '../../widgets/logout_dialog.dart';
import 'delivery_home_screen.dart';
import 'earnings_screen.dart';
import 'notifications_screen.dart';
import 'pickup_task_screen.dart';

/// Delivery profile screen matching the exact design from screenshot
class DeliveryProfileScreen extends StatefulWidget {
  const DeliveryProfileScreen({super.key});

  @override
  State<DeliveryProfileScreen> createState() => _DeliveryProfileScreenState();
}

class _DeliveryProfileScreenState extends State<DeliveryProfileScreen> {
  int _currentNavIndex = 4; // Profile is index 4
  bool _notificationsEnabled = true;

  // Profile image URL
  static const String profileImageUrl =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ThemeHelper.getSurfaceColor(context),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: ThemeHelper.getTextPrimaryColor(context),
              size: 20,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Account',
          style: AppTextStyles.titleLarge.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile header
                    DeliveryProfileHeader(
                      profileImageUrl: profileImageUrl,
                      name: 'Mohamed Tarek',
                      email: 'foxf.com@gmail.com',
                      onEditTap: () {
                        // Handle edit profile
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Account Options
                    DeliveryProfileOptionButton(
                      icon: Icons.account_balance_wallet,
                      title: 'Earnings',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EarningsScreen(),
                          ),
                        );
                      },
                    ),
                    DeliveryProfileOptionButton(
                      icon: Icons.local_shipping,
                      title: 'Mode of Delivery',
                      onTap: () {
                        // Handle mode of delivery
                      },
                    ),
                    DeliveryProfileOptionButton(
                      icon: Icons.wallet,
                      title: 'Your Wallet',
                      onTap: () {
                        // Handle wallet
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Settings section
                    Text(
                      'Settings',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    DeliverySettingsOption(
                      icon: Icons.lock,
                      title: 'Password Manager',
                      onTap: () {
                        // Handle password manager
                      },
                    ),
                    DeliverySettingsOption(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      isToggleOn: _notificationsEnabled,
                      onToggleChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    DeliverySettingsOption(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () {
                        // Handle help center
                      },
                    ),
                    DeliverySettingsOption(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      onTap: () {
                        // Handle privacy policy
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Theme Toggle
                    ThemeToggleSelector(),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Log Out button
                    DeliveryProfileOptionButton(
                      icon: Icons.logout,
                      title: 'Log out',
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withValues(alpha: 0.5),
                          barrierDismissible: true,
                          builder: (context) => const LogoutDialog(),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),
            // Bottom Navigation Bar
            DeliveryBottomNavBar(
              currentIndex: _currentNavIndex,
              notificationCount: 2,
              onTap: (index) {
                if (index == 0) {
                  // Navigate to Home
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const DeliveryHomeScreen(),
                    ),
                  );
                } else if (index == 1) {
                  // Navigate to Earnings
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EarningsScreen(),
                    ),
                  );
                } else if (index == 2) {
                  // Navigate to Pickup Task screen (truck icon)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PickupTaskScreen(),
                    ),
                  );
                } else if (index == 3) {
                  // Navigate to Notifications
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                } else if (index == 4) {
                  // Already on Profile screen
                  setState(() {
                    _currentNavIndex = index;
                  });
                } else {
                  setState(() {
                    _currentNavIndex = index;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

