import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../utils/constants.dart';
import '../../widgets/pickup_location_card.dart';
import '../../widgets/contact_info_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import 'delivery_completion_screen.dart';

/// Pickup task screen with map and information panel
class PickupTaskScreen extends StatelessWidget {
  const PickupTaskScreen({super.key});

  // Profile image URL
  static const String profileImageUrl =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Consumer2<AuthProvider, OrderProvider>(
          builder: (context, authProvider, orderProvider, child) {
            final user = authProvider.user;

            if (user == null || authProvider.userRole != AppConstants.roleDeliveryBoy) {
              return Center(
                child: Text(
                  'Please sign in as a delivery partner to view pickup tasks.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return StreamBuilder<List<OrderModel>>(
              stream: orderProvider.streamDeliveryBoyOrders(user.uid),
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

                // Active pickup order: assigned, picked_up, or in_transit
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

                if (activeOrder == null ||
                    (activeOrder.status != AppConstants.orderStatusAssigned &&
                        activeOrder.status != AppConstants.orderStatusPickedUp &&
                        activeOrder.status != AppConstants.orderStatusInTransit)) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      child: Text(
                        'No pickup tasks available right now.',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: ThemeHelper.getTextPrimaryColor(context),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                // Basic formatting helpers
                String _formatAddress(OrderModel order) {
                  final addr = order.deliveryAddress;
                  return '${addr.street}, ${addr.city}, ${addr.state}, ${addr.zipCode}';
                }

                final customerName = authProvider.userModel?.name ?? 'Customer';
                final customerPhone = authProvider.userModel?.phone ?? 'N/A';

                // Customer (user) coordinates from the delivery address, if present
                final coords = activeOrder.deliveryAddress.coordinates;

                return Column(
                  children: [
                    // Map section (top 2/3)
                    Expanded(
                      flex: 2,
                      child: (coords != null &&
                              coords.containsKey('lat') &&
                              coords.containsKey('lng'))
                          ? GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  coords['lat']!,
                                  coords['lng']!,
                                ),
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId('customer'),
                                  position: LatLng(
                                    coords['lat']!,
                                    coords['lng']!,
                                  ),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueOrange,
                                  ),
                                ),
                              },
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                            )
                          : Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ThemeHelper.getSurfaceColor(context),
                                  ),
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1524661135-423995f22d0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
                                    fit: BoxFit.cover,
                                    headers: const {
                                      'User-Agent':
                                          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: ThemeHelper.getSurfaceColor(context),
                                        child: Center(
                                          child: Icon(
                                            Icons.map,
                                            size: 100,
                                            color:
                                                ThemeHelper.getTextSecondaryColor(context),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                _buildMapMarkers(context),
                              ],
                            ),
                    ),
                    // Information panel (bottom 1/3)
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(
                          AppTheme.spacingL,
                          AppTheme.spacingL,
                          AppTheme.spacingL,
                          AppTheme.spacingM,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeHelper.getBackgroundColor(context),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppTheme.radiusXL),
                            topRight: Radius.circular(AppTheme.radiusXL),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with order number
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Going to Pick Up',
                                      style: AppTextStyles.titleLarge.copyWith(
                                        color: ThemeHelper.getTextPrimaryColor(context),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacingS),
                                  Text(
                                    '#${activeOrder.orderNumber}',
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: ThemeHelper.getPrimaryColor(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              // Pickup / drop-off location card (customer address)
                              PickupLocationCard(
                                address: _formatAddress(activeOrder),
                                icon: Icons.location_on,
                              ),
                              if (activeOrder.deliveryAddress.coordinates != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: AppTheme.spacingS,
                                  ),
                                  child: Text(
                                    'Customer location: '
                                    '${activeOrder.deliveryAddress.coordinates!['lat']?.toStringAsFixed(4)}, '
                                    '${activeOrder.deliveryAddress.coordinates!['lng']?.toStringAsFixed(4)}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: ThemeHelper.getTextSecondaryColor(context),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: AppTheme.spacingM),
                              // Contact info card
                              ContactInfoCard(
                                profileImageUrl: profileImageUrl,
                                name: customerName,
                                phoneNumber: customerPhone,
                                onCallTap: () {
                                  // TODO: integrate with phone dialer
                                },
                                onChatTap: () {
                                  // TODO: integrate with chat
                                },
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              // I've arrived button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (activeOrder == null) return;

                                    // If order is still ASSIGNED, this button means
                                    // "I've arrived at restaurant and picked up".
                                    // If already PICKED_UP or IN_TRANSIT, treat as
                                    // "Mark as done" and complete the delivery.
                                    String nextStatus;
                                    bool goToCompletion = false;

                                    if (activeOrder.status ==
                                        AppConstants.orderStatusAssigned) {
                                      nextStatus =
                                          AppConstants.orderStatusPickedUp;
                                    } else {
                                      nextStatus =
                                          AppConstants.orderStatusDelivered;
                                      goToCompletion = true;
                                    }

                                    final success = await orderProvider
                                        .updateOrderStatus(
                                      activeOrder.id,
                                      nextStatus,
                                    );

                                    if (!context.mounted) return;

                                    if (success) {
                                      if (goToCompletion) {
                                        // Navigate to completion screen with a local
                                        // copy marked as delivered so UI matches.
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DeliveryCompletionScreen(
                                              order: activeOrder!.copyWith(
                                                status: AppConstants
                                                    .orderStatusDelivered,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        // For pickup step just return home.
                                        Navigator.of(context).pop();
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            orderProvider.error ??
                                                'Failed to update order status',
                                          ),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ThemeHelper.getPrimaryColor(context),
                                    foregroundColor: AppColors.textOnPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.radiusM),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    activeOrder.status ==
                                                AppConstants
                                                    .orderStatusAssigned ||
                                            activeOrder.status ==
                                                AppConstants
                                                    .orderStatusPickedUp
                                        ? "I've arrived"
                                        : "Mark as done",
                                    style: AppTextStyles.buttonLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMapMarkers(BuildContext context) {
    return Stack(
      children: [
        // Pickup location marker (yellow house icon - using orange in our theme)
        Positioned(
          top: 80,
          right: 60,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.home,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ThemeHelper.getSurfaceColor(context),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '4 Sultan Bello, Agric, IKD, Lagos...',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Current location marker (green pin with person icon)
        Positioned(
          bottom: 200,
          left: 40,
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.textOnPrimary,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        // Vehicle location marker (white car icon)
        Positioned(
          bottom: 150,
          right: 120,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: ThemeHelper.getSurfaceColor(context),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.directions_car,
              color: ThemeHelper.getTextPrimaryColor(context),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

