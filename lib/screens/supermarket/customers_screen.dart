import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import 'supermarket_dashboard_screen.dart';
import 'order_history_screen.dart';
import 'settings_screen.dart';

/// Customers Screen for POS System
/// Matches the design with orange theme instead of green
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _selectedNavItem = 'Customers';

  // Customer data matching the screenshot
  final List<Map<String, dynamic>> _customers = [
    {
      'name': 'Younes Ashour',
      'id': '#54222',
      'email': 'foxf.com@gmail.com',
      'phone': '+2 01090229396',
      'date': '20/04/2025',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
    },
    {
      'name': 'Ahmad',
      'id': '#54223',
      'email': 'foxf.com@gmail.com',
      'phone': '+2 01090229396',
      'date': '20/04/2025',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop',
    },
    {
      'name': 'Tarek',
      'id': '#54224',
      'email': 'foxf.com@gmail.com',
      'phone': '+2 01090229396',
      'date': '20/04/2025',
      'image': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop',
    },
    {
      'name': 'Waled',
      'id': '#54225',
      'email': 'foxf.com@gmail.com',
      'phone': '+2 01090229396',
      'date': '20/04/2025',
      'image': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=200&h=200&fit=crop',
    },
    {
      'name': 'Mohamed',
      'id': '#54226',
      'email': 'foxf.com@gmail.com',
      'phone': '+2 01090229396',
      'date': '20/04/2025',
      'image': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop',
    },
    {
      'name': 'Eyad',
      'id': '#54226',
      'email': 'foxf.com@gmail.com',
      'phone': '+2 01090229396',
      'date': '20/04/2025',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
    },
  ];

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          // Customers (Active)
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
          // Title
          Text(
            'Customers',
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
              decoration: InputDecoration(
                hintText: 'Search Customers.....',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[500],
                ),
                prefixIcon: Icon(
                  Icons.person_search,
                  color: Colors.grey[500],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingM,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
          // Section Header
          Text(
            'Recent Customers',
            style: AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Customer List
          ..._customers.map((customer) => _buildCustomerCard(customer)),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.isDarkMode(context)
            ? AppColors.darkSurface
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Row(
        children: [
          // Profile Picture
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            child: Image.network(
              customer['image'] as String,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[800],
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: 30,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          // Customer Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer['name'] as String,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customer['id'] as String,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  customer['email'] as String,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  customer['phone'] as String,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          // Date
          Text(
            customer['date'] as String,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

