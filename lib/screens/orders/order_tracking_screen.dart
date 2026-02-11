import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../providers/order_provider.dart';
import '../../providers/delivery_boy_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/order_model.dart';
import '../../models/delivery_boy_model.dart';
import '../../utils/constants.dart';

/// Order Tracking Screen with real-time status updates and delivery progress
class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  bool _useFallbackStream = false; // State to manage stream fallback
  GoogleMapController? _mapController;
  LatLng? _lastDriverPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Consumer2<AuthProvider, OrderProvider>(
          builder: (context, authProvider, orderProvider, child) {
            if (authProvider.user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login,
                      size: 64,
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    Text(
                      'Please sign in to track orders',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: ThemeHelper.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              );
            }

            return StreamBuilder<List<OrderModel>>(
              stream: _useFallbackStream
                  ? orderProvider.streamUserOrdersFallback(authProvider.user!.uid)
                  : orderProvider.streamUserOrders(authProvider.user!.uid),
              builder: (context, snapshot) {
                // Handle index error by switching to fallback stream
                if (snapshot.hasError && !_useFallbackStream) {
                  final errorMsg = snapshot.error.toString();
                  final isIndexError = errorMsg.contains('index') ||
                      errorMsg.contains('requires an index') ||
                      errorMsg.contains('failed-precondition');

                  if (isIndexError) {
                    // Switch to fallback stream automatically
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _useFallbackStream = true;
                        });
                      }
                    });
                    // Show loading while switching
                    return const Center(child: CircularProgressIndicator());
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  final errorMsg = snapshot.error.toString();
                  final isIndexError = errorMsg.contains('index') ||
                      errorMsg.contains('requires an index') ||
                      errorMsg.contains('failed-precondition');

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: AppTheme.spacingL),
                          Text(
                            'Error loading order',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          if (isIndexError)
                            Column(
                              children: [
                                Text(
                                  'Firestore index required',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: ThemeHelper.getTextPrimaryColor(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                Text(
                                  'A composite index is needed for orders. Orders are loading without the index. You can create the index in Firebase Console for better performance.',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: ThemeHelper.getTextSecondaryColor(context),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppTheme.spacingM),
                                // Extract and show the Firebase Console link if available
                                if (errorMsg.contains('https://'))
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                                    child: SelectableText(
                                      errorMsg.substring(
                                        errorMsg.indexOf('https://'),
                                        errorMsg.indexOf(' ', errorMsg.indexOf('https://')) == -1
                                            ? errorMsg.length
                                            : errorMsg.indexOf(' ', errorMsg.indexOf('https://')),
                                      ),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            )
                          else
                            Text(
                              errorMsg,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: ThemeHelper.getTextSecondaryColor(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: AppTheme.spacingL),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Retry loading orders
                                  setState(() {
                                    _useFallbackStream = false;
                                  });
                                },
                                child: const Text('Retry'),
                              ),
                              const SizedBox(width: AppTheme.spacingM),
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Go Back'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }

                OrderModel? order;
                if (snapshot.hasData) {
                  try {
                    order = snapshot.data!.firstWhere((o) => o.id == widget.orderId);
                  } catch (e) {
                    order = null;
                  }
                }

                if (order == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                        const SizedBox(height: AppTheme.spacingL),
                        Text(
                          'Order not found',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: ThemeHelper.getTextPrimaryColor(context),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingL),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Go Back'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Header
                    _buildHeader(order),
                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order Status Progress
                            _buildStatusProgress(order),
                            const SizedBox(height: AppTheme.spacingXL),
                            // Order Details
                            _buildOrderDetails(order),
                            const SizedBox(height: AppTheme.spacingL),
                            // Delivery Address
                            _buildDeliveryAddress(order),
                            const SizedBox(height: AppTheme.spacingL),
                            // Delivery Boy Info (if assigned)
                            if (order.deliveryBoyId != null)
                              _buildDeliveryBoyInfo(order),
                            const SizedBox(height: AppTheme.spacingXL),
                          ],
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

  Widget _buildHeader(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Tracking',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Order #${order.orderNumber}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusProgress(OrderModel order) {
    final statusSteps = _getStatusSteps();
    final currentStepIndex = _getCurrentStepIndex(order.status);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: AppTextStyles.titleMedium.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          ...statusSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isCompleted = index < currentStepIndex;
            final isCurrent = index == currentStepIndex;
            final isCancelled = order.status == AppConstants.orderStatusCancelled;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCancelled
                          ? AppColors.error
                          : (isCompleted || isCurrent
                              ? AppColors.primary
                              : ThemeHelper.getSurfaceColor(context)),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCancelled
                            ? AppColors.error
                            : (isCompleted || isCurrent
                                ? AppColors.primary
                                : ThemeHelper.getBorderColor(context)),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      isCancelled
                          ? Icons.cancel
                          : (isCompleted
                              ? Icons.check
                              : (isCurrent
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked)),
                      color: isCompleted || isCurrent
                          ? AppColors.textOnPrimary
                          : ThemeHelper.getTextSecondaryColor(context),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  // Status Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title']!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isCancelled
                                ? AppColors.error
                                : (isCompleted || isCurrent
                                    ? ThemeHelper.getTextPrimaryColor(context)
                                    : ThemeHelper.getTextSecondaryColor(context)),
                            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        if (step['description'] != null)
                          Text(
                            step['description']!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: ThemeHelper.getTextSecondaryColor(context),
                              fontSize: 12,
                            ),
                          ),
                        if (isCurrent && step['time'] != null)
                          Text(
                            step['time']!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  List<Map<String, String?>> _getStatusSteps() {
    return [
      {
        'title': 'Order Placed',
        'description': 'Your order has been received',
        'time': null,
      },
      {
        'title': 'Order Confirmed',
        'description': 'Restaurant confirmed your order',
        'time': null,
      },
      {
        'title': 'Preparing',
        'description': 'Your food is being prepared',
        'time': null,
      },
      {
        'title': 'Ready for Pickup',
        'description': 'Order is ready for delivery',
        'time': null,
      },
      {
        'title': 'Assigned to Delivery',
        'description': 'Delivery person assigned',
        'time': null,
      },
      {
        'title': 'Picked Up',
        'description': 'Order picked up from restaurant',
        'time': null,
      },
      {
        'title': 'On the Way',
        'description': 'Your order is on the way',
        'time': null,
      },
      {
        'title': 'Delivered',
        'description': 'Order has been delivered',
        'time': null,
      },
    ];
  }

  int _getCurrentStepIndex(String status) {
    switch (status) {
      case AppConstants.orderStatusPending:
        return 0;
      case AppConstants.orderStatusConfirmed:
        return 1;
      case AppConstants.orderStatusPreparing:
        return 2;
      case AppConstants.orderStatusReady:
        return 3;
      case AppConstants.orderStatusAssigned:
        return 4;
      case AppConstants.orderStatusPickedUp:
        return 5;
      case AppConstants.orderStatusInTransit:
        return 6;
      case AppConstants.orderStatusDelivered:
        return 7;
      case AppConstants.orderStatusCancelled:
        return -1; // Special case for cancelled
      default:
        return 0;
    }
  }

  Widget _buildOrderDetails(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: AppTextStyles.titleMedium.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Order Items
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    child: Image.network(
                      item.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: ThemeHelper.getSurfaceColor(context),
                          child: Icon(
                            Icons.image_not_supported,
                            color: ThemeHelper.getTextSecondaryColor(context),
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: ThemeHelper.getTextPrimaryColor(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Qty: ${item.quantity} × £${item.price.toStringAsFixed(2)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: ThemeHelper.getTextSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Price
                  Text(
                    '£${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(),
          const SizedBox(height: AppTheme.spacingM),
          // Price Breakdown
          _buildPriceRow('Subtotal', '£${order.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: AppTheme.spacingS),
          _buildPriceRow('Delivery Fee', '£${order.deliveryFee.toStringAsFixed(2)}'),
          if (order.discount > 0) ...[
            const SizedBox(height: AppTheme.spacingS),
            _buildPriceRow('Discount', '-£${order.discount.toStringAsFixed(2)}'),
          ],
          const SizedBox(height: AppTheme.spacingM),
          const Divider(),
          const SizedBox(height: AppTheme.spacingM),
          _buildPriceRow(
            'Total',
            '£${order.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.titleMedium.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                  fontWeight: FontWeight.bold,
                )
              : AppTextStyles.bodyMedium.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.titleMedium.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                  fontWeight: FontWeight.bold,
                )
              : AppTextStyles.bodyMedium.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddress(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Delivery Address',
                style: AppTextStyles.titleMedium.copyWith(
                  color: ThemeHelper.getTextPrimaryColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            order.deliveryAddress.label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${order.deliveryAddress.street}, ${order.deliveryAddress.city}, ${order.deliveryAddress.state} ${order.deliveryAddress.zipCode}',
            style: AppTextStyles.bodySmall.copyWith(
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          Text(
            order.deliveryAddress.country,
            style: AppTextStyles.bodySmall.copyWith(
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryBoyInfo(OrderModel order) {
    return Consumer<DeliveryBoyProvider>(
      builder: (context, deliveryBoyProvider, child) {
        // Try to get delivery boy info
        DeliveryBoyModel? deliveryBoy;
        try {
          deliveryBoy = deliveryBoyProvider.deliveryBoys
              .firstWhere((db) => db.uid == order.deliveryBoyId);
        } catch (e) {
          deliveryBoy = null;
        }

        if (deliveryBoy == null && order.deliveryBoyId != null) {
          // Load delivery boy if not loaded
          WidgetsBinding.instance.addPostFrameCallback((_) {
            deliveryBoyProvider.loadDeliveryBoys();
          });
        }

        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            color: ThemeHelper.getSurfaceColor(context),
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.delivery_dining,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    'Delivery Information',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              if (deliveryBoy != null) ...[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryContainer,
                      child: deliveryBoy.photoUrl != null
                          ? ClipOval(
                              child: Image.network(
                                deliveryBoy.photoUrl!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                    size: 24,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deliveryBoy.name ?? 'Delivery Person',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (deliveryBoy.phone != null)
                            Text(
                              deliveryBoy.phone!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: ThemeHelper.getTextSecondaryColor(context),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (deliveryBoy.rating > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.warning,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            deliveryBoy.rating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                // Show live location (map on mobile, text fallback on web)
                ...() {
                  final Map<String, double>? loc =
                      order.deliveryBoyLocation ??
                          deliveryBoy?.currentLocation;
                  if (loc == null ||
                      !loc.containsKey('lat') ||
                      !loc.containsKey('lng')) {
                    return <Widget>[];
                  }

                  final lat = loc['lat']!;
                  final lng = loc['lng']!;
                  // On web, avoid google_maps_flutter setup issues and just
                  // show coordinates as text.
                  if (kIsWeb) {
                    return <Widget>[
                      const SizedBox(height: AppTheme.spacingM),
                      Text(
                        'Current Location: '
                        '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      ),
                    ];
                  }

                  final pos = LatLng(lat, lng);

                  // Smoothly move the camera to the latest position
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_mapController != null) {
                      _mapController!.animateCamera(
                        CameraUpdate.newLatLng(pos),
                      );
                    }
                    _lastDriverPosition = pos;
                  });

                  return <Widget>[
                    const SizedBox(height: AppTheme.spacingM),
                    SizedBox(
                      height: 220,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _lastDriverPosition ?? pos,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('driver'),
                            position: pos,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueOrange,
                            ),
                          ),
                        },
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (controller) {
                          _mapController ??= controller;
                        },
                      ),
                    ),
                  ];
                }(),
              ] else ...[
                Text(
                  'Delivery person assigned',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
