import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/order_card.dart';
import '../../widgets/tab_selector.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../models/order_model.dart';
import '../../utils/constants.dart';
import '../cart/shopping_cart_screen.dart';
import 'order_tracking_screen.dart';

/// Production-ready my orders screen with Firestore integration and real-time updates
class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _selectedTabIndex = 0; // 0: Active, 1: Completed, 2: Canceled
  bool _useFallbackStream = false;

  @override
  void initState() {
    super.initState();
    // Load user orders when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      
      if (authProvider.user != null) {
        orderProvider.loadUserOrders(authProvider.user!.uid);
      }
    });
  }

  String _formatOrderDate(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$day/$month/$year At $hour:$minute $period';
  }

  String _getOrderStatusDisplay(String status) {
    switch (status) {
      case AppConstants.orderStatusPending:
      case AppConstants.orderStatusConfirmed:
      case AppConstants.orderStatusPreparing:
      case AppConstants.orderStatusReady:
      case AppConstants.orderStatusAssigned:
      case AppConstants.orderStatusPickedUp:
      case AppConstants.orderStatusInTransit:
        return 'active';
      case AppConstants.orderStatusDelivered:
        return 'completed';
      case AppConstants.orderStatusCancelled:
        return 'canceled';
      default:
        return 'active';
    }
  }

  List<OrderItemData> _convertOrderItems(List<OrderItemModel> items) {
    return items.map((item) {
      // Calculate discount if original price exists
      String discountBadge = '';
      // Note: We don't have original price in OrderItemModel, so we'll leave it empty
      // In a real app, you might want to store original price in the order item
      
      return OrderItemData(
        imageUrl: item.imageUrl,
        title: item.productName,
        quantity: '${item.quantity} ${item.quantity == 1 ? 'item' : 'items'}',
        currentPrice: '£${item.price.toStringAsFixed(2)}',
        originalPrice: '£${item.price.toStringAsFixed(2)}',
        discountBadge: discountBadge,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Tabs
            TabSelector(
              tabs: const ['Active', 'Completed', 'Canceled'],
              selectedIndex: _selectedTabIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
            // Main Content - Order List with Real-time Updates
            Expanded(
              child: Consumer2<AuthProvider, CartProvider>(
                builder: (context, authProvider, cartProvider, child) {
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
                            'Please sign in to view your orders',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: ThemeHelper.getTextSecondaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Use StreamBuilder for real-time updates with automatic fallback
                  final orderProvider = Provider.of<OrderProvider>(context, listen: false);
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
                                  'Error loading orders',
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
                                ElevatedButton(
                                  onPressed: () {
                                    // Retry loading orders
                                    if (authProvider.user != null) {
                                      orderProvider.loadUserOrders(authProvider.user!.uid);
                                    }
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final orders = snapshot.data ?? [];

                      // Filter orders by selected tab
                      List<OrderModel> filteredOrders;
                      if (_selectedTabIndex == 0) {
                        // Active orders
                        filteredOrders = orders.where((order) {
                          return order.status != AppConstants.orderStatusDelivered &&
                              order.status != AppConstants.orderStatusCancelled;
                        }).toList();
                      } else if (_selectedTabIndex == 1) {
                        // Completed orders
                        filteredOrders = orders.where((order) {
                          return order.status == AppConstants.orderStatusDelivered;
                        }).toList();
                      } else {
                        // Canceled orders
                        filteredOrders = orders.where((order) {
                          return order.status == AppConstants.orderStatusCancelled;
                        }).toList();
                      }

                  if (filteredOrders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectedTabIndex == 0
                                ? Icons.shopping_bag_outlined
                                : (_selectedTabIndex == 1
                                    ? Icons.check_circle_outline
                                    : Icons.cancel_outlined),
                            size: 64,
                            color: ThemeHelper.getTextSecondaryColor(context),
                          ),
                          const SizedBox(height: AppTheme.spacingL),
                          Text(
                            _selectedTabIndex == 0
                                ? 'No active orders'
                                : (_selectedTabIndex == 1
                                    ? 'No completed orders'
                                    : 'No canceled orders'),
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            _selectedTabIndex == 0
                                ? 'Your active orders will appear here'
                                : (_selectedTabIndex == 1
                                    ? 'Your completed orders will appear here'
                                    : 'Your canceled orders will appear here'),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: ThemeHelper.getTextSecondaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Column(
                      children: [
                        ...filteredOrders.map((order) {
                          return OrderCard(
                            orderNumber: order.orderNumber,
                            shoppingCartNumber: order.items.length.toString(),
                            orderDate: _formatOrderDate(order.createdAt),
                            orderStatus: _getOrderStatusDisplay(order.status),
                            items: _convertOrderItems(order.items),
                            totalAmount: '£${order.total.toStringAsFixed(2)}',
                            onTrackOrder: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => OrderTrackingScreen(
                                    orderId: order.id,
                                  ),
                                ),
                              );
                            },
                            onCancel: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Cancel Order',
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: ThemeHelper.getTextPrimaryColor(context),
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to cancel this order?',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: ThemeHelper.getTextPrimaryColor(context),
                                    ),
                                  ),
                                  backgroundColor: ThemeHelper.getSurfaceColor(context),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text(
                                        'No',
                                        style: AppTextStyles.buttonMedium.copyWith(
                                          color: ThemeHelper.getTextSecondaryColor(context),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: Text(
                                        'Yes, Cancel',
                                        style: AppTextStyles.buttonMedium.copyWith(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                                final success = await orderProvider.cancelOrder(order.id);
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Order cancelled successfully'),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                } else if (mounted) {
                                  final errorMsg = orderProvider.error ?? "Unknown error";
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error cancelling order: $errorMsg'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              }
                            },
                            onReorder: () {
                              // Add items to cart
                              final productProvider = Provider.of<ProductProvider>(context, listen: false);
                              for (var item in order.items) {
                                try {
                                  final product = productProvider.products.firstWhere(
                                    (p) => p.id == item.productId,
                                  );
                                  // Add item quantity times
                                  for (int i = 0; i < item.quantity; i++) {
                                    cartProvider.addItem(product);
                                  }
                                } catch (e) {
                                  // Product not found, skip it
                                  print('Product ${item.productId} not found for reorder');
                                }
                              }
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ShoppingCartScreen(),
                                ),
                              );
                            },
                            onRate: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Rate order feature coming soon'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                          );
                        }),
                        const SizedBox(height: AppTheme.spacingXL),
                      ],
                    ),
                  );
                    },
                  );
                },
              ),
            ),
            // Bottom Navigation Bar
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return CustomBottomNavBar(
                  currentIndex: 3, // My Order is index 3
                  cartItemCount: cartProvider.itemCount,
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
                    } else if (index == 3) {
                      // Already on My Order screen - do nothing
                    } else {
                      // Handle other navigation items
                      Navigator.of(context).pop();
                    }
                  },
                );
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
            'My orders',
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
