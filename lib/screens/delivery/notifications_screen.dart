import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/notification_item.dart';
import '../../widgets/notification_section_header.dart';
import '../../widgets/delivery_bottom_nav_bar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      final notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
      final deliveryBoy = authProvider.deliveryBoyModel;
      if (deliveryBoy != null) {
        notificationProvider.setDeliveryBoyId(deliveryBoy.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider =
        Provider.of<NotificationProvider>(context);
    final unreadCount = notificationProvider.unreadCount;

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
            if (unreadCount > 0) ...[
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
                  '$unreadCount NEW',
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
              child: _buildContent(context, notificationProvider),
            ),
            // Bottom Navigation Bar
            DeliveryBottomNavBar(
              currentIndex: _currentNavIndex,
              notificationCount: unreadCount,
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

  Widget _buildContent(
    BuildContext context,
    NotificationProvider notificationProvider,
  ) {
    if (notificationProvider.isLoading &&
        notificationProvider.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notificationProvider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Text(
            notificationProvider.error!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final notifications = notificationProvider.notifications;

    if (notifications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Text(
            'No notifications yet',
            style: AppTextStyles.bodyMedium.copyWith(
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
        ),
      );
    }

    // Simple grouping into "TODAY" and "EARLIER" based on date
    final now = DateTime.now();
    bool isToday(AppNotification n) {
      final d = n.createdAt.toLocal();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }

    final today = notifications.where(isToday).toList();
    final earlier = notifications.where((n) => !isToday(n)).toList();

    String _timeAgo(AppNotification n) {
      final diff = now.difference(n.createdAt);
      if (diff.inMinutes < 1) return 'now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      return '${diff.inDays}d';
    }

    List<Widget> _buildSection(String title, List<AppNotification> data) {
      if (data.isEmpty) return [];

      return [
        NotificationSectionHeader(
          title: title,
          onMarkAllAsRead: () {
            notificationProvider.markAllAsRead();
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingL,
            AppTheme.spacingM,
            AppTheme.spacingL,
            AppTheme.spacingM,
          ),
          child: Column(
            children: data
                .map(
                  (n) => NotificationItem(
                    icon: Icons.notifications,
                    title: n.title,
                    description: n.message,
                    timeAgo: _timeAgo(n),
                    isRead: n.isRead,
                    onTap: () {
                      notificationProvider.markAsRead(n.id);
                      // TODO: Handle navigation based on n.type/orderId
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ];
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildSection('TODAY', today),
          if (today.isNotEmpty && earlier.isNotEmpty)
            Divider(
              color: ThemeHelper.getBorderColor(context),
              thickness: 1,
            ),
          ..._buildSection('EARLIER', earlier),
          const SizedBox(height: AppTheme.spacingL),
        ],
      ),
    );
  }
}

