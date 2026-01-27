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
import '../product/product_detail_screen.dart';
import '../category/category_detail_screen.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/product_model.dart';

/// Production-ready home screen matching the exact design from screenshot
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load categories and products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      
      categoryProvider.loadCategories();
      productProvider.loadAllProducts();
    });
  }

  // Get category image URL (fallback to default if not provided)
  String _getCategoryImageUrl(CategoryModel category) {
    if (category.imageUrl != null && category.imageUrl!.isNotEmpty) {
      return category.imageUrl!;
    }
    // Default images based on category name
    final categoryName = category.name.toLowerCase();
    if (categoryName.contains('main') || categoryName.contains('course')) {
      return 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200&h=200&fit=crop';
    } else if (categoryName.contains('salad')) {
      return 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=200&h=200&fit=crop';
    } else if (categoryName.contains('veg')) {
      return 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=200&h=200&fit=crop';
    } else if (categoryName.contains('non') || categoryName.contains('meat')) {
      return 'https://images.unsplash.com/photo-1532550907401-a78c000e25fb?w=200&h=200&fit=crop';
    } else if (categoryName.contains('dessert')) {
      return 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=200&h=200&fit=crop';
    }
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
                      child: Column(
                        children: [
                          // Location and Notification
                          LocationHeader(
                            location: 'New York, USA',
                            hasNotification: true,
                            onLocationTap: () {
                              // Handle location tap
                            },
                            onNotificationTap: () {
                              // Handle notification tap
                            },
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          // Search Bar
                          CustomSearchBar(
                            onTap: () {
                              // Handle search tap
                            },
                            onSettingsTap: () {
                              // Handle settings tap
                            },
                          ),
                        ],
                      ),
                    ),

                    // Offer Banner Carousel Section
                    const SizedBox(height: AppTheme.spacingS),
                    OfferCarousel(
                      banners: [
                        {
                          'title': 'Premium Biryani!',
                          'description': 'Delicious chicken biryani with aromatic spices',
                          'buttonText': 'Order Now',
                          'illustrationUrl': 'chickensmoke.png',
                        },
                        {
                          'title': 'Fresh Sushi!',
                          'description': 'Experience authentic Japanese flavors',
                          'buttonText': 'Order Now',
                          'illustrationUrl': 'suhismoke.jpg',
                        },
                        {
                          'title': 'Gourmet Eggs!',
                          'description': 'Perfectly prepared eggs with premium ingredients',
                          'buttonText': 'Order Now',
                          'illustrationUrl': 'eggsmoke.jpg',
                        },
                      ],
                      onButtonTap: () {
                        // Handle shop now tap
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
                              // Handle see all categories
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
                              // Handle see all deals
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
                                        content: Text('${product.name} added to cart'),
                                        backgroundColor: AppColors.primary,
                                        duration: const Duration(seconds: 1),
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
}
