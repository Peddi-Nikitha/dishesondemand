import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_item.dart';
import '../../widgets/offer_carousel.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/location_header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../cart/shopping_cart_screen.dart';
import '../favourite/favourite_screen.dart';
import '../orders/my_orders_screen.dart';
import '../profile/my_account_screen.dart';
import '../profile/addresses_screen.dart';
import '../product/product_search_screen.dart';
import '../category/all_categories_screen.dart';
import '../product/all_products_screen.dart';
import '../product/product_detail_screen.dart';
import '../category/category_detail_screen.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';
import '../../services/location_service.dart';
import '../../widgets/location_permission_dialog.dart';
import 'package:geolocator/geolocator.dart';
import '../delivery/notifications_screen.dart';

/// Production-ready home screen matching the exact design from screenshot
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  String? _currentLocationLabel;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    // Load categories and products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      
      categoryProvider.loadCategories();
      productProvider.loadAllProducts();
      
      // Initialize user notifications if user is logged in
      final user = authProvider.userModel;
      if (user != null && authProvider.userRole == 'user') {
        notificationProvider.setUserId(user.uid);
      }
      
      // Automatically get current device location
      _getCurrentDeviceLocation();
    });
  }
  
  /// Automatically get and display current device location
  Future<void> _getCurrentDeviceLocation() async {
    // Check if location service is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return; // Silently fail - user can manually set location
    }

    // Check current permission status
    var permission = await Geolocator.checkPermission();
    
    // If permission is denied or denied forever, don't try to get location
    if (permission == LocationPermission.denied || 
        permission == LocationPermission.deniedForever) {
      return; // Silently fail - user can manually set location
    }

    // Permission granted, get current location
    if (permission == LocationPermission.whileInUse || 
        permission == LocationPermission.always) {
      setState(() {
        _isLoadingLocation = true;
      });

      try {
        // Get current position
        final position = await LocationService.getCurrentPosition();
        if (position == null) {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }

        // Reverse geocode to get address
        final addressData = await LocationService.reverseGeocode(
          position.latitude,
          position.longitude,
        );

        if (addressData != null && mounted) {
          // Build location label from geocoded data - include street for exact location
          final street = addressData['street'] ?? '';
          final streetName = addressData['streetName'] ?? '';
          final city = addressData['city'] ?? '';
          final state = addressData['state'] ?? '';
          final country = addressData['country'] ?? '';
          
          String locationLabel = 'Current Location';
          
          // Build detailed location label with street name
          if (street.isNotEmpty) {
            // Show full street address with city
            locationLabel = street;
            if (city.isNotEmpty) {
              locationLabel = '$street, $city';
            }
          } else if (streetName.isNotEmpty) {
            // Show street name even without door number
            locationLabel = streetName;
            if (city.isNotEmpty) {
              locationLabel = '$streetName, $city';
            }
          } else if (city.isNotEmpty) {
            // Fallback to city and state
            locationLabel = city;
            if (state.isNotEmpty) {
              locationLabel = '$city, $state';
            }
          } else if (country.isNotEmpty) {
            locationLabel = country;
          }
          
          debugPrint('📍 Current location: $locationLabel');
          
          setState(() {
            _currentLocationLabel = locationLabel;
            _isLoadingLocation = false;
          });
        } else {
          setState(() {
            _isLoadingLocation = false;
          });
        }
      } catch (e) {
        // Silently handle errors - don't block UI
        if (mounted) {
          setState(() {
            _isLoadingLocation = false;
          });
        }
      }
    }
  }

  /// Handle Order Now button tap - find product, add to cart, and navigate to cart page
  Future<void> _handleOrderNow(
    BuildContext context,
    String searchTerm,
    ProductProvider productProvider,
  ) async {
    if (searchTerm.isEmpty) return;

    try {
      // Ensure products are loaded
      if (productProvider.products.isEmpty) {
        await productProvider.loadAllProducts();
      }

      if (productProvider.products.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No products available at the moment'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // Find product by name (case-insensitive search)
      final searchLower = searchTerm.toLowerCase();
      ProductModel? product;
      
      try {
        product = productProvider.products.firstWhere(
          (p) => p.name.toLowerCase().contains(searchLower),
        );
      } catch (e) {
        // If exact match not found, try to find any product with similar name
        product = productProvider.products.firstWhere(
          (p) => p.name.toLowerCase().contains(searchLower.substring(0, searchLower.length > 3 ? 3 : searchLower.length)),
          orElse: () => productProvider.products.first,
        );
      }

      // Add product to cart
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.addItem(product);

      // Show success message and navigate to cart page
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${product.name} added to cart',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              bottom: 80,
              left: 16,
              right: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
          ),
        );

        // Navigate to cart page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ShoppingCartScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // Get category image URL (fallback to default if not provided)
  String _getCategoryImageUrl(CategoryModel category) {
    if (category.imageUrl != null && category.imageUrl!.isNotEmpty) {
      return category.imageUrl!;
    }
    // Default images based on category name
    final categoryName = category.name.toLowerCase();
    
    // Starters/Appetizers
    if (categoryName.contains('starter') || categoryName.contains('appetizer')) {
      return 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=200&h=200&fit=crop';
    }
    // Breakfast
    else if (categoryName.contains('breakfast') || categoryName.contains('morning')) {
      return 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=200&h=200&fit=crop';
    }
    // Lunch
    else if (categoryName.contains('lunch') || categoryName.contains('midday')) {
      return 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=200&h=200&fit=crop';
    }
    // Supper/Dinner
    else if (categoryName.contains('supp') || categoryName.contains('supper') || 
             categoryName.contains('dinner') || categoryName.contains('evening')) {
      return 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200&h=200&fit=crop';
    }
    // Desserts
    else if (categoryName.contains('dessert') || categoryName.contains('sweet')) {
      return 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=200&h=200&fit=crop';
    }
    // Beverages/Drinks
    else if (categoryName.contains('bev') || categoryName.contains('beverage') || 
             categoryName.contains('drink') || categoryName.contains('beverages')) {
      return 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=200&h=200&fit=crop';
    }
    // Main Course
    else if (categoryName.contains('main') || categoryName.contains('course')) {
      return 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200&h=200&fit=crop';
    }
    // Salads
    else if (categoryName.contains('salad')) {
      return 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=200&h=200&fit=crop';
    }
    // Vegetarian
    else if (categoryName.contains('veg') && !categoryName.contains('non')) {
      return 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=200&h=200&fit=crop';
    }
    // Non-Vegetarian/Meat
    else if (categoryName.contains('non') || categoryName.contains('meat')) {
      return 'https://images.unsplash.com/photo-1532550907401-a78c000e25fb?w=200&h=200&fit=crop';
    }
    // Default fallback
    return 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200&h=200&fit=crop';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Main scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          final user = authProvider.userModel;
                          final locationLabel =
                              _buildUserLocationLabel(user);

                          return Column(
                            children: [
                              // Location and Notification
                              Consumer<NotificationProvider>(
                                builder: (context, notificationProvider, _) {
                                  return LocationHeader(
                                location: locationLabel,
                                    hasNotification: notificationProvider.unreadCount > 0,
                                onLocationTap: () => _handleLocationTap(context, authProvider),
                                onNotificationTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const NotificationsScreen(),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                          const SizedBox(height: AppTheme.spacingM),
                              // Search Bar
                              CustomSearchBar(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ProductSearchScreen(),
                                    ),
                                  );
                                },
                                onSettingsTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MyAccountScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // Offer Banner Carousel Section
                    const SizedBox(height: AppTheme.spacingS),
                    Consumer<ProductProvider>(
                      builder: (context, productProvider, _) {
                        return OfferCarousel(
                      banners: [
                        {
                          'title': 'Premium Biryani!',
                          'description': 'Delicious chicken biryani with aromatic spices',
                          'buttonText': 'Order Now',
                          'illustrationUrl': 'chickensmoke.png',
                              'productSearchTerm': 'biryani',
                        },
                        {
                          'title': 'Fresh Sushi!',
                          'description': 'Experience authentic Japanese flavors',
                          'buttonText': 'Order Now',
                          'illustrationUrl': 'suhismoke.jpg',
                              'productSearchTerm': 'sushi',
                        },
                        {
                          'title': 'Gourmet Eggs!',
                          'description': 'Perfectly prepared eggs with premium ingredients',
                          'buttonText': 'Order Now',
                          'illustrationUrl': 'eggsmoke.jpg',
                              'productSearchTerm': 'egg',
                        },
                      ],
                          onButtonTap: (searchTerm) async {
                            await _handleOrderNow(context, searchTerm, productProvider);
                          },
                        );
                      },
                    ),

                    // Category Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppTheme.spacingM,
                        AppTheme.spacingL,
                        AppTheme.spacingM,
                        AppTheme.spacingM,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                          Text(
                            'Category',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AllCategoriesScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'See All',
                              style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
            ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, child) {
                        if (categoryProvider.isLoading && categoryProvider.categories.isEmpty) {
                          return const SizedBox(
                            height: 110,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        
                        if (categoryProvider.error != null && categoryProvider.categories.isEmpty) {
                          return SizedBox(
                            height: 110,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Error loading categories',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.error,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      categoryProvider.clearError();
                                      categoryProvider.loadCategories();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final categories = categoryProvider.categories
                            .where((c) => c.isActive)
                            .toList()
                          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

                        return SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                        ),
                            children: categories.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: CategoryItem(
                                  imageUrl: _getCategoryImageUrl(category),
                                  label: category.name,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                        builder: (context) => CategoryDetailScreen(
                                          categoryName: category.name,
                                  ),
                                ),
                              );
                            },
                                ),
                              );
                            }).toList(),
                                ),
                              );
                            },
                    ),

                    // Best Deal Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppTheme.spacingM,
                        AppTheme.spacingL,
                        AppTheme.spacingM,
                        AppTheme.spacingM,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
            Text(
                            'Best Deal',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AllProductsScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'See All',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer2<ProductProvider, AuthProvider>(
                      builder: (context, productProvider, authProvider, child) {
                        if (productProvider.isLoading && productProvider.products.isEmpty) {
                          return const SizedBox(
                      height: 245,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        
                        if (productProvider.error != null && productProvider.products.isEmpty) {
                          return SizedBox(
                            height: 245,
                            child: Center(
                              child: Text(
                                'Error loading products',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.error,
                                ),
                                  ),
                                ),
                              );
                        }

                        final products = productProvider.products.take(15).toList();

                        if (products.isEmpty) {
                          return SizedBox(
                            height: 245,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.restaurant_menu,
                                    size: 48,
                                    color: ThemeHelper.getTextSecondaryColor(context),
                                  ),
                                  const SizedBox(height: AppTheme.spacingM),
                                  Text(
                                    'No products available',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: ThemeHelper.getTextSecondaryColor(context),
                                    ),
                                  ),
                                ],
                                  ),
                                ),
                              );
                        }

                        return SizedBox(
                          height: 245,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingM,
                            ),
                            children: products.map((product) {
                              final isFavorite = authProvider.isFavorite(product.id);
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: ProductCard(
                                  imageUrl: product.imageUrl,
                                  title: product.name,
                                  quantity: product.quantity,
                                  currentPrice: product.formattedCurrentPrice,
                                  originalPrice: product.originalPrice != null
                                      ? product.formattedOriginalPrice
                                      : null,
                            isFavorite: isFavorite,
                            onFavoriteTap: () async {
                              final success = await authProvider.toggleFavorite(product.id);
                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? '${product.name} removed from favorites'
                                          : '${product.name} added to favorites',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            onAddTap: () {
                                    final cartProvider = Provider.of<CartProvider>(context, listen: false);
                                    cartProvider.addItem(product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            const Icon(Icons.check_circle, color: Colors.white),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                '${product.name} added to cart',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: AppColors.primary,
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.only(
                                          bottom: 80,
                                          left: 16,
                                          right: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 6,
                                      ),
                              );
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                          productId: product.id,
                                  ),
                                ),
                              );
                            },
                                ),
                              );
                            }).toList(),
                                ),
                              );
                            },
                    ),
                    // Products are now loaded from Firestore via ProductProvider
                    // All old hardcoded products have been removed
                    // Bottom padding to prevent overflow
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return CustomBottomNavBar(
              currentIndex: _currentNavIndex,
                  cartItemCount: cartProvider.itemCount,
              onTap: (index) {
                if (index == 1) {
                  // Navigate to Shopping Cart
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ShoppingCartScreen(),
                    ),
                  );
                } else if (index == 2) {
                  // Navigate to Favourite
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FavouriteScreen(),
                    ),
                  );
                } else if (index == 3) {
                  // Navigate to My Orders
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyOrdersScreen(),
                    ),
                  );
                } else if (index == 4) {
                  // Navigate to Profile
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyAccountScreen(),
                    ),
                  );
                } else {
                  setState(() {
                    _currentNavIndex = index;
                  });
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

  /// Build a human-readable label for the user's current/default address.
  /// Prioritizes current device location, then saved addresses.
  /// Falls back to a generic string if no address is saved yet.
  String _buildUserLocationLabel(UserModel? user) {
    // First priority: Show current device location if available
    if (_currentLocationLabel != null && _currentLocationLabel!.isNotEmpty) {
      return _currentLocationLabel!;
    }
    
    // Second priority: Show saved addresses
    if (user != null && user.addresses.isNotEmpty) {
      // Prefer default address if set.
      final List<AddressModel> addresses = user.addresses;
      AddressModel address =
          addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first);

      // If we have coordinates, we could display a short city + country or just label.
      // For now show "Label, City".
      final city = address.city.isNotEmpty ? address.city : '';
      if (city.isEmpty) {
        return address.label;
      }
      return '${address.label}, $city';
    }
    
    // Fallback: Show generic message
    if (_isLoadingLocation) {
      return 'Getting location...';
    }
    return 'Choose your address';
  }

  /// Handle location tap - refresh current location or show address selection
  Future<void> _handleLocationTap(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final user = authProvider.userModel;
    
    // If user has addresses, show address selection screen
    if (user != null && user.addresses.isNotEmpty) {
      // Show bottom sheet with options: refresh location or select from saved addresses
      showModalBottomSheet(
        context: context,
        backgroundColor: ThemeHelper.getSurfaceColor(context),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.my_location, color: AppColors.primary),
                title: const Text('Use Current Location'),
                subtitle: const Text('Update location from GPS'),
                onTap: () {
                  Navigator.pop(context);
                  _refreshCurrentLocation(context, authProvider);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.location_on, color: AppColors.primary),
                title: const Text('Select from Saved Addresses'),
                subtitle: const Text('Choose from your saved addresses'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AddressesScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
      return;
    }

    // If no saved addresses, try to get current location
    await _refreshCurrentLocation(context, authProvider);
  }
  
  /// Refresh current location and optionally save it
  Future<void> _refreshCurrentLocation(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    // Check if location service is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable location services in your device settings'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // Check current permission status
    var permission = await Geolocator.checkPermission();
    
    // If permission is denied, show permission dialog
    if (permission == LocationPermission.denied) {
      if (context.mounted) {
        await _showLocationPermissionDialog(context, authProvider);
      }
      return;
    }

    // If permission is denied forever, show settings message
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is permanently denied. Please enable it in settings'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // Permission granted, get current location and save it
    // This will also update the display label
    await _getAndSaveCurrentLocation(context, authProvider);
  }

  /// Show location permission dialog
  Future<void> _showLocationPermissionDialog(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => LocationPermissionDialog(
        onAllow: () async {
          Navigator.of(context).pop(true);
          // Request permission
          final permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            // Permission granted, get and save location
            await _getAndSaveCurrentLocation(context, authProvider);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Location permission is required to use this feature'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }
        },
        onMaybeLater: () {
          Navigator.of(context).pop(false);
          // Show address selection screen instead
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddressesScreen(),
            ),
          );
        },
      ),
    );
  }

  /// Get current location, reverse geocode, and save as address
  Future<void> _getAndSaveCurrentLocation(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    if (!context.mounted) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Get current position
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to get your current location'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // Reverse geocode to get address
      final addressData = await LocationService.reverseGeocode(
        position.latitude,
        position.longitude,
      );

      if (addressData == null) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to get address from location'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // Build location label for display - include street for exact location
      final street = addressData['street'] ?? '';
      final streetName = addressData['streetName'] ?? '';
      final city = addressData['city'] ?? '';
      final state = addressData['state'] ?? '';
      
      String locationLabel = 'Current Location';
      
      // Build detailed location label with street name
      if (street.isNotEmpty) {
        // Show full street address with city
        locationLabel = street;
        if (city.isNotEmpty) {
          locationLabel = '$street, $city';
        }
      } else if (streetName.isNotEmpty) {
        // Show street name even without door number
        locationLabel = streetName;
        if (city.isNotEmpty) {
          locationLabel = '$streetName, $city';
        }
      } else if (city.isNotEmpty) {
        // Fallback to city and state
        locationLabel = city;
        if (state.isNotEmpty) {
          locationLabel = '$city, $state';
        }
      } else if (addressData['country']?.isNotEmpty == true) {
        locationLabel = addressData['country']!;
      }
      
      debugPrint('📍 Refreshed location: $locationLabel');
      
      // Update current location label in state
      if (mounted) {
        setState(() {
          _currentLocationLabel = locationLabel;
        });
      }

      // Create address model
      final address = AddressModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        label: 'Current Location',
        street: addressData['street'] ?? '',
        city: addressData['city'] ?? '',
        state: addressData['state'] ?? '',
        zipCode: addressData['zipCode'] ?? '',
        country: addressData['country'] ?? '',
        isDefault: true, // Set as default since it's the current location
        coordinates: {
          'lat': position.latitude,
          'lng': position.longitude,
        },
      );

      // Save address
      final success = await authProvider.addAddress(address);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Current location saved successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authProvider.error ?? 'Failed to save location',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
