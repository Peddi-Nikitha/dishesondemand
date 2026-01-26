import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import 'supermarket_dashboard_screen.dart';
import 'customers_screen.dart';
import 'order_history_screen.dart';

/// Settings Screen for POS System
/// Matches the design with orange theme instead of green
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavItem = 'Settings';
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['Market', 'Employees', 'Items'];

  // Form controllers
  final _restaurantNameController = TextEditingController(text: 'Restaurant OX');
  final _restaurantPhoneController = TextEditingController(text: '+2 01090229396');
  final _restaurantMailController = TextEditingController(text: 'foxf.com@gmail.com');
  final _restaurantAddressController = TextEditingController(text: 'New Cairo - Egypt');
  final _restaurantFacebookController = TextEditingController(text: 'Restaurant Facebook');
  final _restaurantXController = TextEditingController(text: 'Restaurant X.com');
  final _restaurantTikTokController = TextEditingController(text: 'Restaurant TikTok');
  final _restaurantYouTubeController = TextEditingController(text: 'Restaurant YouTube');
  final _currencyController = TextEditingController(text: '\$');
  final _generalDiscountController = TextEditingController(text: '%');

  bool _deliveryEnabled = false;
  bool _orderReservationEnabled = false;
  File? _selectedLogoImage;

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
    } else if (item == 'Order') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OrderHistoryScreen(),
        ),
      );
    }
  }

  Future<void> _pickLogoImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedLogoImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _restaurantPhoneController.dispose();
    _restaurantMailController.dispose();
    _restaurantAddressController.dispose();
    _restaurantFacebookController.dispose();
    _restaurantXController.dispose();
    _restaurantTikTokController.dispose();
    _restaurantYouTubeController.dispose();
    _currencyController.dispose();
    _generalDiscountController.dispose();
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
                // Tabs
                _buildTabs(),
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
          // Settings (Active)
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

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      color: ThemeHelper.isDarkMode(context)
          ? AppColors.darkSurface
          : const Color(0xFF2A2A2A),
      child: Row(
        children: List.generate(
          _tabs.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingS),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingS,
                ),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == index
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Text(
                  _tabs[index],
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
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Information Section
          Text(
            'Restaurant Information',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Restaurant Name
          _buildInputField(
            label: 'Restaurant name',
            icon: Icons.restaurant,
            controller: _restaurantNameController,
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Restaurant Phone
          _buildInputField(
            label: 'Restaurant phone',
            icon: Icons.phone,
            controller: _restaurantPhoneController,
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Restaurant Mail
          _buildInputField(
            label: 'Restaurant mail',
            icon: Icons.mail,
            controller: _restaurantMailController,
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Restaurant Address
          _buildInputField(
            label: 'Restaurant address',
            icon: Icons.location_on,
            controller: _restaurantAddressController,
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Restaurant Facebook
          _buildInputField(
            label: 'Restaurant Facebook',
            icon: Icons.facebook,
            controller: _restaurantFacebookController,
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Restaurant X.com
          _buildInputField(
            label: 'Restaurant X.com',
            icon: Icons.close, // Using close icon as placeholder for X logo
            controller: _restaurantXController,
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Restaurant TikTok
          _buildInputField(
            label: 'Restaurant TikTok',
            icon: Icons.music_note, // Using music note as placeholder for TikTok logo
            controller: _restaurantTikTokController,
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Restaurant YouTube
          _buildInputField(
            label: 'Restaurant YouTube',
            icon: Icons.play_circle,
            controller: _restaurantYouTubeController,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          // Restaurant Logo Section
          Text(
            'Restaurant Logo',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              // Upload Area
              Expanded(
                child: GestureDetector(
                  onTap: _pickLogoImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          color: AppColors.primary,
                          size: 48,
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        Text(
                          'Open a file or drag and drop an',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              // Current Logo Display
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: _selectedLogoImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        child: Image.file(
                          _selectedLogoImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=200&h=200&fit=crop',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.restaurant,
                                size: 60,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Save Button for Logo
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Handle save logo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Logo saved successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
              ),
              child: Text(
                'Save',
                style: AppTextStyles.buttonLarge,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
          // Restaurant Settings Section
          Text(
            'Restaurant Settings',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Currency Input
          _buildSettingsInputField(
            label: 'Currency',
            icon: Icons.attach_money,
            controller: _currencyController,
            hint: '\$',
          ),
          const SizedBox(height: AppTheme.spacingM),
          // General Discount Input
          _buildSettingsInputField(
            label: 'General discount',
            icon: Icons.percent,
            controller: _generalDiscountController,
            hint: '%',
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Delivery Option
          _buildToggleOption(
            label: 'delivery',
            question: 'Does the restaurant offer home delivery?',
            value: _deliveryEnabled,
            onChanged: (value) {
              setState(() {
                _deliveryEnabled = value;
              });
            },
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Order Reservation Option
          _buildToggleOption(
            label: 'order reservation',
            question: 'Is pre-order available?',
            value: _orderReservationEnabled,
            onChanged: (value) {
              setState(() {
                _orderReservationEnabled = value;
              });
            },
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Save Button for Settings
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Handle save settings
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Settings saved successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
              ),
              child: Text(
                'Save',
                style: AppTextStyles.buttonLarge,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Container(
          decoration: BoxDecoration(
            color: ThemeHelper.isDarkMode(context)
                ? AppColors.darkSurface
                : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(
              color: AppColors.primary,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: AppColors.primary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingM,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Container(
          decoration: BoxDecoration(
            color: ThemeHelper.isDarkMode(context)
                ? AppColors.darkSurface
                : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(
              color: AppColors.primary,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: AppColors.primary,
              ),
              hintText: hint,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
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
      ],
    );
  }

  Widget _buildToggleOption({
    required String label,
    required String question,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.isDarkMode(context)
            ? AppColors.darkSurface
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  question,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            inactiveThumbColor: Colors.grey[600],
            inactiveTrackColor: Colors.grey[800],
          ),
        ],
      ),
    );
  }
}

