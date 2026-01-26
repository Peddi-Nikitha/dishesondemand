import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/order_card.dart';
import '../../widgets/tab_selector.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../cart/shopping_cart_screen.dart';
import '../../models/menu_item.dart';

/// Production-ready my orders screen matching the exact design
class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _selectedTabIndex = 0; // 0: Active, 1: Completed, 2: Canceled

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
              tabs: const ['Active', 'Competed', 'Canceled'],
              selectedIndex: _selectedTabIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
            // Main Content - Order List
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: _buildOrderList(),
              ),
            ),
            // Bottom Navigation Bar
            CustomBottomNavBar(
              currentIndex: 3, // My Order is index 3
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
                } else if (index == 3) {
                  // Already on My Order screen - do nothing
                } else {
                  // Handle other navigation items
                  Navigator.of(context).pop();
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

  Widget _buildOrderList() {
    // Helper method to get image URL from MenuData
    String _getImageUrl(String itemName) {
      final allItems = MenuData.allItems;
      final item = allItems.firstWhere(
        (item) => item.name == itemName,
        orElse: () => allItems.first,
      );
      return item.imageUrl;
    }

    if (_selectedTabIndex == 0) {
      // Active orders
      return Column(
        children: [
          OrderCard(
            orderNumber: '#122',
            shoppingCartNumber: '3',
            orderDate: '20/Oct/2025 At 11:21 pm',
            orderStatus: 'active',
            items: [
              OrderItemData(
                imageUrl: _getImageUrl('Margherita Pizza'),
                title: 'Margherita Pizza',
                quantity: '1 large',
                currentPrice: '\$20',
                originalPrice: '\$24',
                discountBadge: '35% OFF',
              ),
              OrderItemData(
                imageUrl: _getImageUrl('Creamy Pasta'),
                title: 'Creamy Pasta',
                quantity: '1 serving',
                currentPrice: '\$15',
                originalPrice: '\$18',
                discountBadge: '35% OFF',
              ),
            ],
            totalAmount: '\$35.40',
            onTrackOrder: () {
              // Handle track order
            },
            onCancel: () {
              // Handle cancel order
            },
          ),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      );
    } else if (_selectedTabIndex == 1) {
      // Completed orders
      return Column(
        children: [
          OrderCard(
            orderNumber: '#121',
            shoppingCartNumber: '2',
            orderDate: '20/Oct/2025 At 11:21 pm',
            orderStatus: 'completed',
            items: [
              OrderItemData(
                imageUrl: _getImageUrl('Margherita Pizza'),
                title: 'Margherita Pizza',
                quantity: '1 large',
                currentPrice: '\$20',
                originalPrice: '\$24',
                discountBadge: '35% OFF',
              ),
              OrderItemData(
                imageUrl: _getImageUrl('Creamy Pasta'),
                title: 'Creamy Pasta',
                quantity: '1 serving',
                currentPrice: '\$15',
                originalPrice: '\$18',
                discountBadge: '35% OFF',
              ),
            ],
            totalAmount: '\$35.00',
            onReorder: () {
              // Navigate to shopping cart
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ShoppingCartScreen(),
                ),
              );
            },
            onRate: () {
              // Handle rate order
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Rate order feature coming soon'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
          // Second order card
          OrderCard(
            orderNumber: '#121',
            shoppingCartNumber: '2',
            orderDate: '20/Oct/2025 At 11:21 pm',
            orderStatus: 'completed',
            items: [
              OrderItemData(
                imageUrl: _getImageUrl('Creamy Pasta'),
                title: 'Creamy Pasta',
                quantity: '1 serving',
                currentPrice: '\$15',
                originalPrice: '\$18',
                discountBadge: '35% OFF',
              ),
            ],
            totalAmount: '\$15.00',
            onReorder: () {
              // Navigate to shopping cart
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ShoppingCartScreen(),
                ),
              );
            },
            onRate: () {
              // Handle rate order
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Rate order feature coming soon'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      );
    } else {
      // Canceled orders
      return Column(
        children: [
          OrderCard(
            orderNumber: '#119',
            shoppingCartNumber: '2',
            orderDate: '20/May/2025 At 11:21 pm',
            orderStatus: 'canceled',
            items: [
              OrderItemData(
                imageUrl: _getImageUrl('Margherita Pizza'),
                title: 'Margherita Pizza',
                quantity: '1 large',
                currentPrice: '\$20',
                originalPrice: '\$24',
                discountBadge: '35% OFF',
              ),
              OrderItemData(
                imageUrl: _getImageUrl('Creamy Pasta'),
                title: 'Creamy Pasta',
                quantity: '1 serving',
                currentPrice: '\$15',
                originalPrice: '\$18',
                discountBadge: '35% OFF',
              ),
            ],
            totalAmount: '\$35.40',
            onReorder: () {
              // Navigate to shopping cart
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ShoppingCartScreen(),
                ),
              );
            },
            onRate: () {
              // Handle rate order
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Rate order feature coming soon'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
          // Second order card
          OrderCard(
            orderNumber: '#119',
            shoppingCartNumber: '2',
            orderDate: '20/May/2025 At 11:21 pm',
            orderStatus: 'canceled',
            items: [
              OrderItemData(
                imageUrl: _getImageUrl('Creamy Pasta'),
                title: 'Creamy Pasta',
                quantity: '1 serving',
                currentPrice: '\$15',
                originalPrice: '\$18',
                discountBadge: '35% OFF',
              ),
            ],
            totalAmount: '\$15.40',
            onReorder: () {
              // Navigate to shopping cart
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ShoppingCartScreen(),
                ),
              );
            },
            onRate: () {
              // Handle rate order
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Rate order feature coming soon'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      );
    }
  }
}

