import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/delivery_quick_action_card.dart';
import '../../widgets/current_shipping_card.dart';
import '../../widgets/recent_shipment_item.dart';
import '../../widgets/delivery_bottom_nav_bar.dart';
import 'notifications_screen.dart';
import 'earnings_screen.dart';
import 'delivery_profile_screen.dart';
import 'pickup_task_screen.dart';
import 'delivery_completion_screen.dart';

/// Delivery driver home screen matching the exact design from screenshot
class DeliveryHomeScreen extends StatefulWidget {
  const DeliveryHomeScreen({super.key});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  int _currentNavIndex = 0;

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
            // Top section with profile and quick actions
            _buildTopSection(context),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacingL),
                    // Current Shipping card
                    const CurrentShippingCard(
                      shippingId: 'REG1023456789',
                      status: 'Transit',
                      originDate: '30 Des 2025',
                      originLocation: 'Agric. IKD. Lag.',
                      destinationDate: '31 Des 2025',
                      destinationLocation: 'New Cairo 112 flor 1',
                      progress: 0.7,
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Recent Shipment section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Shipment',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          // Shipment list
                          RecentShipmentItem(
                            shipmentId: 'REG1023456789',
                            origin: 'Lekki',
                            destination: 'Gbagada',
                            status: 'Detivered',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const DeliveryCompletionScreen(),
                                ),
                              );
                            },
                          ),
                          RecentShipmentItem(
                            shipmentId: 'REG9782456789',
                            origin: 'Magodo',
                            destination: 'Victoria Island',
                            status: 'Not Delivered',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const DeliveryCompletionScreen(),
                                ),
                              );
                            },
                          ),
                          RecentShipmentItem(
                            shipmentId: 'REG8231456789',
                            origin: 'Ogudu',
                            destination: 'Ikorodu',
                            status: 'Detivered',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const DeliveryCompletionScreen(),
                                ),
                              );
                            },
                          ),
                          RecentShipmentItem(
                            shipmentId: 'REG1553456789',
                            origin: 'Lekki',
                            destination: 'Gbagada',
                            status: 'Detivered',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const DeliveryCompletionScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppTheme.spacingXL),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Navigation Bar
            DeliveryBottomNavBar(
              currentIndex: _currentNavIndex,
              notificationCount: 2,
              onTap: (index) {
                if (index == 1) {
                  // Navigate to Earnings screen
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
                  // Navigate to Notifications screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
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

  Widget _buildTopSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile section
          Row(
            children: [
              // Profile image
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ThemeHelper.getPrimaryColor(context),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    profileImageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    headers: const {
                      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: ThemeHelper.getSurfaceColor(context),
                        child: Icon(
                          Icons.person,
                          color: ThemeHelper.getTextSecondaryColor(context),
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              // Name and edit
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Mohamed',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        // Handle edit profile
                      },
                      child: Text(
                        'Edit your profile',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: ThemeHelper.getPrimaryColor(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Quick action cards grid
          Row(
            children: [
              Expanded(
                child: DeliveryQuickActionCard(
                  icon: Icons.location_on,
                  title: 'Your Location',
                  subtitle: 'New Cairo m E...',
                  onTap: () {
                    // Handle location tap
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: DeliveryQuickActionCard(
                  icon: Icons.explore,
                  title: 'New Tracking',
                  subtitle: 'Tracking by ID',
                  onTap: () {
                    // Handle tracking tap
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Expanded(
                child: DeliveryQuickActionCard(
                  icon: Icons.account_balance_wallet,
                  title: 'My wallet',
                  subtitle: '\$3450.30',
                  onTap: () {
                    // Handle wallet tap
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Container(), // Empty space for 2x2 grid
              ),
            ],
          ),
        ],
      ),
    );
  }
}

