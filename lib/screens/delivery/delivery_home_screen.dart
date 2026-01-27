import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/delivery_quick_action_card.dart';
import '../../widgets/current_shipping_card.dart';
import '../../widgets/recent_shipment_item.dart';
import '../../widgets/delivery_bottom_nav_bar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/order_model.dart';
import '../../utils/constants.dart';
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
  void initState() {
    super.initState();
    // Load assigned orders for the current delivery boy
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
      final user = authProvider.user;
      if (user != null) {
        orderProvider.loadDeliveryBoyOrders(user.uid);
        notificationProvider.setDeliveryBoyId(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Consumer3<AuthProvider, OrderProvider, NotificationProvider>(
          builder:
              (context, authProvider, orderProvider, notificationProvider, child) {
            final user = authProvider.user;

            // Filter orders for this delivery boy using real-time stream
            return Column(
              children: [
                // Top section with profile and quick actions
                _buildTopSection(context, authProvider),
                // Main content
                Expanded(
                  child: StreamBuilder<List<OrderModel>>(
                    stream: user != null
                        ? orderProvider.streamDeliveryBoyOrders(user.uid)
                        : const Stream.empty(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingL),
                            child: Text(
                              snapshot.error.toString(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: ThemeHelper.getTextSecondaryColor(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      final orders = snapshot.data ?? [];

                      // Determine active order (assigned / picked_up / in_transit)
                      OrderModel? activeOrder;
                      if (orders.isNotEmpty) {
                        activeOrder = orders.firstWhere(
                          (order) =>
                              order.status == AppConstants.orderStatusAssigned ||
                              order.status == AppConstants.orderStatusPickedUp ||
                              order.status == AppConstants.orderStatusInTransit,
                          orElse: () => orders.first,
                        );
                      }

                      final hasActiveOrder = activeOrder != null;

                      // Recent shipments (all orders)
                      final recentOrders = orders;

                      if (orders.isEmpty) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingL),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: AppTheme.spacingL),
                                Center(
                                  child: Text(
                                    'No assigned deliveries yet',
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: ThemeHelper.getTextPrimaryColor(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingXL),
                              ],
                            ),
                          ),
                        );
                      }

                      String _formatDate(DateTime date) {
                        final d = date.toLocal();
                        return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
                      }

                      String _statusLabel(String status) {
                        switch (status) {
                          case AppConstants.orderStatusAssigned:
                            return 'Assigned';
                          case AppConstants.orderStatusPickedUp:
                            return 'Picked Up';
                          case AppConstants.orderStatusInTransit:
                            return 'In Transit';
                          case AppConstants.orderStatusDelivered:
                            return 'Delivered';
                          default:
                            return status;
                        }
                      }

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppTheme.spacingL),
                            if (hasActiveOrder)
                              CurrentShippingCard(
                                shippingId: activeOrder.orderNumber,
                                status: _statusLabel(activeOrder.status),
                                originDate: _formatDate(activeOrder.createdAt),
                                originLocation: 'Restaurant',
                                destinationDate: _formatDate(activeOrder.createdAt),
                                destinationLocation:
                                    activeOrder.deliveryAddress.city,
                                progress: activeOrder.status ==
                                        AppConstants.orderStatusAssigned
                                    ? 0.3
                                    : activeOrder.status ==
                                            AppConstants.orderStatusPickedUp
                                        ? 0.6
                                        : activeOrder.status ==
                                                AppConstants.orderStatusInTransit
                                            ? 0.9
                                            : 1.0,
                              ),
                            if (hasActiveOrder)
                              const SizedBox(height: AppTheme.spacingXL),
                            // Recent Shipment section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingL),
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
                                  ...recentOrders.map((order) {
                                    return RecentShipmentItem(
                                      shipmentId: order.orderNumber,
                                      origin: 'Restaurant',
                                      destination: order.deliveryAddress.city,
                                      status: _statusLabel(order.status),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DeliveryCompletionScreen(
                                              order: order,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                  const SizedBox(height: AppTheme.spacingXL),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Bottom Navigation Bar
                DeliveryBottomNavBar(
                  currentIndex: _currentNavIndex,
                  notificationCount: notificationProvider.unreadCount,
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, AuthProvider authProvider) {
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
                      'Hi, ${authProvider.deliveryBoyModel?.name ?? 'Driver'}',
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

