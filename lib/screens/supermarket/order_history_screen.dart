import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/logout_dialog.dart';
import '../../utils/constants.dart';
import '../../providers/order_provider.dart';
import '../../providers/delivery_boy_provider.dart';
import '../../models/order_model.dart';
import '../../models/delivery_boy_model.dart';
import 'supermarket_dashboard_screen.dart';
import 'customers_screen.dart';
import 'settings_screen.dart';

/// Order History Screen for POS System
/// Matches the design with orange theme instead of green
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _selectedNavItem = 'Order';
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['Order History', 'Order On Hold', 'Offline Order'];

  @override
  void initState() {
    super.initState();
    // Load orders from Firestore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.loadAllOrders();
      orderProvider.setSelectedTab(_tabs[_selectedTabIndex]);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _selectNavItem(String item) {
    setState(() {
      _selectedNavItem = item;
    });
    _scaffoldKey.currentState?.closeDrawer();
    
    // Navigate based on selection
    if (item == 'Home') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SupermarketDashboardScreen(),
        ),
      );
    } else if (item == 'Customers') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CustomersScreen(),
        ),
      );
    } else if (item == 'Settings') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeHelper.isDarkMode(context)
          ? AppColors.darkBackground
          : const Color(0xFF1A1A1A),
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          // Left Sidebar (always visible on desktop/tablet, drawer on mobile)
          if (!isMobile) _buildSidebar(),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(),
                // Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: ThemeHelper.isDarkMode(context)
          ? AppColors.darkSurface
          : const Color(0xFF2A2A2A),
      width: 80,
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 80,
      color: ThemeHelper.isDarkMode(context)
          ? AppColors.darkSurface
          : const Color(0xFF2A2A2A),
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebarContent() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: AppTheme.spacingL),
          // Home
          _buildNavItem(
            icon: Icons.home,
            label: 'Home',
            isActive: _selectedNavItem == 'Home',
            onTap: () => _selectNavItem('Home'),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Customers
          _buildNavItem(
            icon: Icons.person,
            label: 'Customers',
            isActive: _selectedNavItem == 'Customers',
            onTap: () => _selectNavItem('Customers'),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Order (Active)
          _buildNavItem(
            icon: Icons.point_of_sale,
            label: 'Order',
            isActive: _selectedNavItem == 'Order',
            onTap: () => _selectNavItem('Order'),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Reports
          _buildNavItem(
            icon: Icons.bar_chart,
            label: 'Reports',
            isActive: _selectedNavItem == 'Reports',
            onTap: () => _selectNavItem('Reports'),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Settings
          _buildNavItem(
            icon: Icons.settings,
            label: 'Settings',
            isActive: _selectedNavItem == 'Settings',
            onTap: () => _selectNavItem('Settings'),
          ),
          const Spacer(),
          // Profile Picture
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 30,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Logout
          _buildNavItem(
            icon: Icons.power_settings_new,
            label: 'Logout',
            isActive: false,
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => const LogoutDialog(),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingL),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.spacingM,
          horizontal: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.textOnPrimary
                  : ThemeHelper.getTextSecondaryColor(context),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isActive
                    ? AppColors.textOnPrimary
                    : ThemeHelper.getTextSecondaryColor(context),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingM,
      ),
      color: ThemeHelper.isDarkMode(context)
          ? AppColors.darkSurface
          : const Color(0xFF2A2A2A),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hamburger Menu
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: _openDrawer,
          ),
          // Right Icons
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Handle refresh
                },
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: const Icon(
                  Icons.wifi,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
            child: Row(
              children: List.generate(
                _tabs.length,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppTheme.spacingS),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                        orderProvider.setSelectedTab(_tabs[index]);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingM,
                          horizontal: AppTheme.spacingS,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == index
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Text(
                          _tabs[index],
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _selectedTabIndex == index
                                ? AppColors.textOnPrimary
                                : Colors.white,
                            fontWeight: _selectedTabIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: ThemeHelper.isDarkMode(context)
                  ? AppColors.darkSurface
                  : const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
              ),
              onChanged: (value) {
                final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                orderProvider.setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Order Id or Customers.',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[500],
                ),
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Colors.grey[500],
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingM,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingS,
            ),
            decoration: BoxDecoration(
              color: ThemeHelper.isDarkMode(context)
                  ? AppColors.darkSurface
                  : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Order ID',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total Sales',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          // Order List
          Consumer<OrderProvider>(
            builder: (context, orderProvider, _) {
              if (orderProvider.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppTheme.spacingXL),
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                );
              }

              if (orderProvider.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingXL),
                    child: Column(
                      children: [
                        Text(
                          orderProvider.error!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        ElevatedButton(
                          onPressed: () {
                            orderProvider.loadAllOrders();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final orders = orderProvider.orders;
              if (orders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingXL),
                    child: Text(
                      'No orders found',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: orders.map((order) => _buildOrderRow(order)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderRow(OrderModel order) {
    final bool isDelivered = order.status == AppConstants.orderStatusDelivered;
    final bool isCancelled = order.status == AppConstants.orderStatusCancelled;
    final bool canAssign = !isDelivered && !isCancelled;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingM,
      ),
      decoration: BoxDecoration(
        color: ThemeHelper.isDarkMode(context)
            ? AppColors.darkSurface
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              order.orderNumber,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${order.createdAt.day}/${order.createdAt.month} ${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')} ${order.createdAt.hour >= 12 ? 'PM' : 'AM'}',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '£${order.total.toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.deliveryBoyId != null
                      ? 'Assigned'
                      : 'Unassigned',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: order.deliveryBoyId != null
                        ? AppColors.success
                        : AppColors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: canAssign
                        ? () => _showAssignDeliveryDialog(order)
                        : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textOnPrimary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      textStyle: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(
                      order.deliveryBoyId != null ? 'Reassign' : 'Assign',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAssignDeliveryDialog(OrderModel order) async {
    final deliveryBoyProvider =
        Provider.of<DeliveryBoyProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Load all delivery boys
    await deliveryBoyProvider.loadDeliveryBoys();

    if (!mounted) return;

    String? selectedDeliveryBoyId = order.deliveryBoyId;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            // Use all delivery boys (regardless of status)
            final List<DeliveryBoyModel> deliveryBoys =
                List<DeliveryBoyModel>.from(deliveryBoyProvider.deliveryBoys);

            return AlertDialog(
              backgroundColor: ThemeHelper.isDarkMode(context)
                  ? AppColors.darkSurface
                  : Colors.white,
              title: const Text('Assign Delivery Boy'),
              content: deliveryBoyProvider.isLoading
                  ? const SizedBox(
                      height: 80,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : deliveryBoys.isEmpty
                      ? const Text(
                          'No active delivery boys available.',
                        )
                      : DropdownButtonFormField<String>(
                          value: selectedDeliveryBoyId,
                          decoration: const InputDecoration(
                            labelText: 'Select Delivery Boy',
                          ),
                          items: deliveryBoys.map((db) {
                            return DropdownMenuItem<String>(
                              value: db.uid,
                              child: Text(db.name ?? db.email),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDeliveryBoyId = value;
                            });
                          },
                        ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: (selectedDeliveryBoyId == null ||
                          deliveryBoyProvider.isLoading)
                      ? null
                      : () async {
                          final success = await orderProvider.assignDeliveryBoy(
                            order.id,
                            selectedDeliveryBoyId!,
                          );
                          if (!mounted) return;

                          Navigator.of(dialogContext).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Order assigned successfully'
                                    : orderProvider.error ??
                                        'Failed to assign order',
                              ),
                              backgroundColor: success
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          );
                        },
                  child: const Text('Assign'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

