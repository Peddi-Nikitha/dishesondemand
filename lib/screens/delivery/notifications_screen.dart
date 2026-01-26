import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/notification_item.dart';
import '../../widgets/notification_section_header.dart';
import '../../widgets/delivery_bottom_nav_bar.dart';
import 'delivery_home_screen.dart';
import 'delivery_profile_screen.dart';
import 'pickup_task_screen.dart';

/// Delivery notifications screen matching the exact design from screenshot
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _currentNavIndex = 3; // Notifications is index 3
  int _unreadCount = 2;

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notification',
              style: AppTextStyles.titleLarge.copyWith(
                color: ThemeHelper.getTextPrimaryColor(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_unreadCount > 0) ...[
              const SizedBox(width: AppTheme.spacingS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                decoration: BoxDecoration(
                  color: ThemeHelper.getPrimaryColor(context),
                  borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
                ),
                child: Text(
                  '$_unreadCount NEW',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingL,
                  AppTheme.spacingM,
                  AppTheme.spacingL,
                  AppTheme.spacingM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODAY section
                    NotificationSectionHeader(
                      title: 'TODAY',
                      onMarkAllAsRead: () {
                        setState(() {
                          _unreadCount = 0;
                        });
                        // Handle mark all as read
                      },
                    ),
                    // TODAY notifications
                    NotificationItem(
                      icon: Icons.calendar_today,
                      title: 'Tour Booked Successfully',
                      description:
                          'Lorem ipsum dolor sit amet consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      timeAgo: '1h',
                      onTap: () {
                        // Handle notification tap
                      },
                    ),
                    NotificationItem(
                      icon: Icons.percent,
                      title: 'Exclusive Offers Inside',
                      description:
                          'Lorem ipsum dolor sit ametr consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      timeAgo: '1h',
                      onTap: () {
                        // Handle notification tap
                      },
                    ),
                    NotificationItem(
                      icon: Icons.star_border,
                      title: 'Property Review Request',
                      description:
                          'Lorem ipsum dolor sit ametr consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      timeAgo: '1h',
                      onTap: () {
                        // Handle notification tap
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    // Divider
                    Divider(
                      color: ThemeHelper.getBorderColor(context),
                      thickness: 1,
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    // YESTERDAY section
                    NotificationSectionHeader(
                      title: 'YESTERDAY',
                      onMarkAllAsRead: () {
                        // Handle mark all as read
                      },
                    ),
                    // YESTERDAY notifications
                    NotificationItem(
                      icon: Icons.calendar_today,
                      title: 'Tour Booked Successfully',
                      description:
                          'Lorem ipsum dolor sit ametr consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      timeAgo: '1h',
                      onTap: () {
                        // Handle notification tap
                      },
                    ),
                    NotificationItem(
                      icon: Icons.percent,
                      title: 'Exclusive Offers Inside',
                      description:
                          'Lorem ipsum dolor sit ametr consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      timeAgo: '1h',
                      onTap: () {
                        // Handle notification tap
                      },
                    ),
                    NotificationItem(
                      icon: Icons.star_border,
                      title: 'Property Review Request',
                      description:
                          'Lorem ipsum dolor sit ametr consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      timeAgo: '1h',
                      onTap: () {
                        // Handle notification tap
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                  ],
                ),
              ),
            ),
            // Bottom Navigation Bar
            DeliveryBottomNavBar(
              currentIndex: _currentNavIndex,
              notificationCount: _unreadCount,
              onTap: (index) {
                if (index == 0) {
                  // Navigate to Home
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const DeliveryHomeScreen(),
                    ),
                  );
                } else if (index == 2) {
                  // Navigate to Pickup Task screen (truck icon)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PickupTaskScreen(),
                    ),
                  );
                } else if (index == 4) {
                  // Navigate to Profile screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DeliveryProfileScreen(),
                    ),
                  );
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

