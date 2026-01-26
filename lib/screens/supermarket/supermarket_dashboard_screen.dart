import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import 'customers_screen.dart';
import 'order_history_screen.dart';
import 'settings_screen.dart';

/// Supermarket Dashboard (POS System) Screen
/// Matches the design with orange theme instead of green
class SupermarketDashboardScreen extends StatefulWidget {
  const SupermarketDashboardScreen({super.key});

  @override
  State<SupermarketDashboardScreen> createState() => _SupermarketDashboardScreenState();
}

class _SupermarketDashboardScreenState extends State<SupermarketDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedCategoryIndex = 0;
  String _selectedNavItem = 'Home';

  final List<String> _categories = ['Starters', 'Breakfast', 'Lunch', 'Supp', 'Desserts', 'Beverages'];

  // Product data organized by category
  final Map<String, List<Map<String, dynamic>>> _productsByCategory = {
    'Starters': [
      {
        'name': 'Schezwan Egg',
        'price': 24.00,
        'image': 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&h=400&fit=crop',
      },
      {
        'name': 'Spring Rolls',
        'price': 12.00,
        'image': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=400&fit=crop',
      },
      {
        'name': 'Chicken Wings',
        'price': 18.00,
        'image': 'https://images.unsplash.com/photo-1527477396000-e27137b2a8c3?w=400&h=400&fit=crop',
      },
      {
        'name': 'Bruschetta',
        'price': 10.00,
        'image': 'https://images.unsplash.com/photo-1572441713132-51c75654db73?w=400&h=400&fit=crop',
      },
      {
        'name': 'Mozzarella Sticks',
        'price': 14.00,
        'image': 'https://images.unsplash.com/photo-1527477396000-e27137b2a8c3?w=400&h=400&fit=crop',
      },
      {
        'name': 'Onion Rings',
        'price': 9.00,
        'image': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=400&fit=crop',
      },
    ],
    'Breakfast': [
      {
        'name': 'Pancakes',
        'price': 15.00,
        'image': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=400&fit=crop',
      },
      {
        'name': 'French Toast',
        'price': 14.00,
        'image': 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=400&h=400&fit=crop',
      },
      {
        'name': 'Eggs Benedict',
        'price': 18.00,
        'image': 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=400&h=400&fit=crop',
      },
      {
        'name': 'Waffles',
        'price': 16.00,
        'image': 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=400&h=400&fit=crop',
      },
      {
        'name': 'Omelette',
        'price': 12.00,
        'image': 'https://images.unsplash.com/photo-1615367423057-4b9c38e5c724?w=400&h=400&fit=crop',
      },
      {
        'name': 'Breakfast Burrito',
        'price': 13.00,
        'image': 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400&h=400&fit=crop',
      },
      {
        'name': 'Avocado Toast',
        'price': 11.00,
        'image': 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400&h=400&fit=crop',
      },
      {
        'name': 'Breakfast Sandwich',
        'price': 10.00,
        'image': 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&h=400&fit=crop',
      },
    ],
    'Lunch': [
      {
        'name': 'Caesar Salad',
        'price': 16.00,
        'image': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=400&fit=crop',
      },
      {
        'name': 'Grilled Chicken',
        'price': 22.00,
        'image': 'https://images.unsplash.com/photo-1532550907401-a78c000e25fb?w=400&h=400&fit=crop',
      },
      {
        'name': 'Beef Burger',
        'price': 20.00,
        'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=400&fit=crop',
      },
      {
        'name': 'Fish & Chips',
        'price': 19.00,
        'image': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&h=400&fit=crop',
      },
      {
        'name': 'Pasta Carbonara',
        'price': 18.00,
        'image': 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=400&fit=crop',
      },
      {
        'name': 'Club Sandwich',
        'price': 17.00,
        'image': 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&h=400&fit=crop',
      },
      {
        'name': 'Chicken Wrap',
        'price': 15.00,
        'image': 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400&h=400&fit=crop',
      },
      {
        'name': 'Pizza Slice',
        'price': 14.00,
        'image': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&h=400&fit=crop',
      },
    ],
    'Supp': [
      {
        'name': 'Steak Dinner',
        'price': 32.00,
        'image': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=400&fit=crop',
      },
      {
        'name': 'Salmon Fillet',
        'price': 28.00,
        'image': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&h=400&fit=crop',
      },
      {
        'name': 'Lamb Chops',
        'price': 30.00,
        'image': 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400&h=400&fit=crop',
      },
      {
        'name': 'Ribeye Steak',
        'price': 35.00,
        'image': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=400&fit=crop',
      },
      {
        'name': 'Grilled Fish',
        'price': 26.00,
        'image': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&h=400&fit=crop',
      },
      {
        'name': 'Pork Tenderloin',
        'price': 27.00,
        'image': 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400&h=400&fit=crop',
      },
      {
        'name': 'Chicken Breast',
        'price': 24.00,
        'image': 'https://images.unsplash.com/photo-1532550907401-a78c000e25fb?w=400&h=400&fit=crop',
      },
      {
        'name': 'Beef Tenderloin',
        'price': 33.00,
        'image': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=400&fit=crop',
      },
    ],
    'Desserts': [
      {
        'name': 'Chocolate Cake',
        'price': 12.00,
        'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=400&fit=crop',
      },
      {
        'name': 'Cheesecake',
        'price': 13.00,
        'image': 'https://images.unsplash.com/photo-1524351199676-942e0d5d8ff3?w=400&h=400&fit=crop',
      },
      {
        'name': 'Ice Cream',
        'price': 8.00,
        'image': 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&h=400&fit=crop',
      },
      {
        'name': 'Tiramisu',
        'price': 14.00,
        'image': 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&h=400&fit=crop',
      },
      {
        'name': 'Brownie',
        'price': 10.00,
        'image': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=400&fit=crop',
      },
      {
        'name': 'Apple Pie',
        'price': 11.00,
        'image': 'https://images.unsplash.com/photo-1621303837174-89787a7d4729?w=400&h=400&fit=crop',
      },
      {
        'name': 'Creme Brulee',
        'price': 12.00,
        'image': 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400&h=400&fit=crop',
      },
      {
        'name': 'Chocolate Mousse',
        'price': 11.00,
        'image': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=400&fit=crop',
      },
    ],
    'Beverages': [
      {
        'name': 'Fresh Orange Juice',
        'price': 6.00,
        'image': 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&h=400&fit=crop',
      },
      {
        'name': 'Coffee',
        'price': 5.00,
        'image': 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400&h=400&fit=crop',
      },
      {
        'name': 'Iced Tea',
        'price': 4.00,
        'image': 'https://images.unsplash.com/photo-1556679343-c7306c1976b5?w=400&h=400&fit=crop',
      },
      {
        'name': 'Smoothie',
        'price': 7.00,
        'image': 'https://images.unsplash.com/photo-1505252585461-04c3a695d0a5?w=400&h=400&fit=crop',
      },
      {
        'name': 'Lemonade',
        'price': 5.00,
        'image': 'https://images.unsplash.com/photo-1523677011783-c91d1bbe2fdc?w=400&h=400&fit=crop',
      },
      {
        'name': 'Coca Cola',
        'price': 3.00,
        'image': 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&h=400&fit=crop',
      },
      {
        'name': 'Milkshake',
        'price': 8.00,
        'image': 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&h=400&fit=crop',
      },
      {
        'name': 'Fresh Lemonade',
        'price': 5.00,
        'image': 'https://images.unsplash.com/photo-1523677011783-c91d1bbe2fdc?w=400&h=400&fit=crop',
      },
    ],
  };

  // Get products for selected category
  List<Map<String, dynamic>> get _currentProducts {
    final selectedCategory = _categories[_selectedCategoryIndex];
    return _productsByCategory[selectedCategory] ?? [];
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
    if (item == 'Customers') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CustomersScreen(),
        ),
      );
    } else if (item == 'Order') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OrderHistoryScreen(),
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
          : const Color(0xFF1A1A1A), // Very dark background
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
                // Category Tabs
                _buildCategoryTabs(),
                // Product Grid
                Expanded(
                  child: _buildProductGrid(),
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
          // Home (Active)
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
          // Order
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
              Navigator.of(context).pop();
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
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: _openDrawer,
          ),
          // Right Icons
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Handle refresh
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.wifi,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Handle Wi-Fi
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      color: ThemeHelper.isDarkMode(context)
          ? AppColors.darkSurface
          : const Color(0xFF2A2A2A),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Cash Register Icon
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingS),
              child: Icon(
                Icons.point_of_sale,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            // Category Tabs
            ...List.generate(
              _categories.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: AppTheme.spacingS),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedCategoryIndex == index
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: Text(
                      _categories[index],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _selectedCategoryIndex == index
                            ? AppColors.textOnPrimary
                            : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _currentProducts;
    
    if (products.isEmpty) {
      return Center(
        child: Text(
          'No products available',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppTheme.spacingM,
          mainAxisSpacing: AppTheme.spacingM,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeHelper.isDarkMode(context)
            ? AppColors.darkSurface
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusL),
                topRight: Radius.circular(AppTheme.radiusL),
              ),
              child: Image.network(
                product['image'] as String,
                width: double.infinity,
                fit: BoxFit.cover,
                headers: const {
                  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                  'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                      size: 40,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product['name'] as String,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product['price'].toStringAsFixed(2)}',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

