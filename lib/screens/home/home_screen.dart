import 'package:flutter/material.dart';
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
import '../../models/menu_item.dart';

/// Production-ready home screen matching the exact design from screenshot
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  // Get images from MenuData to ensure consistency
  String _getImageUrl(String itemName) {
    final allItems = MenuData.allItems;
    final item = allItems.firstWhere(
      (item) => item.name == itemName,
      orElse: () => allItems.first,
    );
    return item.imageUrl;
  }

  // Category images - realistic food images
  static const String mainCourseUrl =
      'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200&h=200&fit=crop';
  static const String saladsUrl =
      'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=200&h=200&fit=crop';
  static const String vegUrl =
      'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=200&h=200&fit=crop';
  static const String nonVegUrl =
      'https://images.unsplash.com/photo-1532550907401-a78c000e25fb?w=200&h=200&fit=crop';
  static const String dessertsUrl =
      'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=200&h=200&fit=crop';

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
                    SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                        ),
                        children: [
                          CategoryItem(
                            imageUrl: mainCourseUrl,
                            label: 'Main Course',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CategoryDetailScreen(
                                    categoryName: 'Main Course',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 20),
                          CategoryItem(
                            imageUrl: saladsUrl,
                            label: 'Salads',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CategoryDetailScreen(
                                    categoryName: 'Salads',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 20),
                          CategoryItem(
                            imageUrl: vegUrl,
                            label: 'Veg',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CategoryDetailScreen(
                                    categoryName: 'Veg',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 20),
                          CategoryItem(
                            imageUrl: nonVegUrl,
                            label: 'Non-Veg',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CategoryDetailScreen(
                                    categoryName: 'Non-Veg',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 20),
                          CategoryItem(
                            imageUrl: dessertsUrl,
                            label: 'Desserts',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CategoryDetailScreen(
                                    categoryName: 'Desserts',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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
                    SizedBox(
                      height: 245,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                        ),
                        children: [
                          // Main Course Items
                          ProductCard(
                            imageUrl: _getImageUrl('Creamy Pasta'),
                            title: 'Creamy Pasta',
                            quantity: '1 serving',
                            currentPrice: '\$15',
                            originalPrice: '\$18',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Creamy Pasta',
                                    category: 'Main Course',
                                    imageUrl: _getImageUrl('Creamy Pasta'),
                                    price: '\$15.00',
                                    rating: 4.5,
                                    quantity: '1 serving',
                                    description:
                                        'Delicious creamy pasta with fresh ingredients and authentic Italian flavors. Perfectly cooked and seasoned to perfection.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Mushroom Risotto'),
                            title: 'Mushroom Risotto',
                            quantity: '1 serving',
                            currentPrice: '\$16',
                            originalPrice: '\$20',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Mushroom Risotto',
                                    category: 'Main Course',
                                    imageUrl: _getImageUrl('Mushroom Risotto'),
                                    price: '\$16.00',
                                    rating: 4.6,
                                    quantity: '1 serving',
                                    description:
                                        'Creamy arborio rice cooked with fresh mushrooms, parmesan cheese, and white wine. A classic Italian comfort dish.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Beef Lasagna'),
                            title: 'Beef Lasagna',
                            quantity: '1 serving',
                            currentPrice: '\$18',
                            originalPrice: '\$22',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Beef Lasagna',
                                    category: 'Main Course',
                                    imageUrl: _getImageUrl('Beef Lasagna'),
                                    price: '\$18.00',
                                    rating: 4.7,
                                    quantity: '1 serving',
                                    description:
                                        'Layered pasta with rich meat sauce, creamy béchamel, and melted cheese. Baked to golden perfection.',
                                  ),
                                ),
                              );
                            },
                          ),
                          // Non-Veg Items
                          ProductCard(
                            imageUrl: _getImageUrl('Grilled Chicken'),
                            title: 'Grilled Chicken',
                            quantity: '1 serving',
                            currentPrice: '\$18',
                            originalPrice: '\$22',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Grilled Chicken',
                                    category: 'Non-Veg',
                                    imageUrl: _getImageUrl('Grilled Chicken'),
                                    price: '\$18.00',
                                    rating: 4.9,
                                    quantity: '1 serving',
                                    description:
                                        'Tender grilled chicken breast marinated in herbs and spices, served with roasted vegetables and signature sauce. Perfectly cooked to juicy perfection.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Premium Steak'),
                            title: 'Premium Steak',
                            quantity: '1 serving',
                            currentPrice: '\$32',
                            originalPrice: '\$38',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Premium Steak',
                                    category: 'Non-Veg',
                                    imageUrl: _getImageUrl('Premium Steak'),
                                    price: '\$32.00',
                                    rating: 4.8,
                                    quantity: '1 serving',
                                    description:
                                        'Prime cut steak grilled to perfection, served with mashed potatoes, seasonal vegetables, and rich gravy. A premium dining experience.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Lamb Chops'),
                            title: 'Lamb Chops',
                            quantity: '1 serving',
                            currentPrice: '\$26',
                            originalPrice: '\$30',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Lamb Chops',
                                    category: 'Non-Veg',
                                    imageUrl: _getImageUrl('Lamb Chops'),
                                    price: '\$26.00',
                                    rating: 4.7,
                                    quantity: '1 serving',
                                    description:
                                        'Tender lamb chops marinated in Mediterranean herbs, grilled to perfection. Served with mint sauce and roasted vegetables.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Grilled Salmon'),
                            title: 'Grilled Salmon',
                            quantity: '1 serving',
                            currentPrice: '\$24',
                            originalPrice: '\$28',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Grilled Salmon',
                                    category: 'Non-Veg',
                                    imageUrl: _getImageUrl('Grilled Salmon'),
                                    price: '\$24.00',
                                    rating: 4.8,
                                    quantity: '1 serving',
                                    description:
                                        'Fresh Atlantic salmon grilled with lemon and herbs, served with steamed vegetables and dill sauce. Healthy and delicious.',
                                  ),
                                ),
                              );
                            },
                          ),
                          // Veg Items
                          ProductCard(
                            imageUrl: _getImageUrl('Veg Pasta'),
                            title: 'Veg Pasta',
                            quantity: '1 serving',
                            currentPrice: '\$14',
                            originalPrice: '\$17',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Veg Pasta',
                                    category: 'Veg',
                                    imageUrl: _getImageUrl('Veg Pasta'),
                                    price: '\$14.00',
                                    rating: 4.5,
                                    quantity: '1 serving',
                                    description:
                                        'Fresh pasta with seasonal vegetables, tomato sauce, and herbs. A vegetarian delight packed with flavor.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Veg Supreme Pizza'),
                            title: 'Veg Supreme Pizza',
                            quantity: '1 large',
                            currentPrice: '\$18',
                            originalPrice: '\$22',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Veg Supreme Pizza',
                                    category: 'Veg',
                                    imageUrl: _getImageUrl('Veg Supreme Pizza'),
                                    price: '\$18.00',
                                    rating: 4.6,
                                    quantity: '1 large',
                                    description:
                                        'Loaded with fresh vegetables, bell peppers, mushrooms, olives, and cheese. A vegetarian favorite.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Vegetable Curry'),
                            title: 'Vegetable Curry',
                            quantity: '1 serving',
                            currentPrice: '\$13',
                            originalPrice: '\$16',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Vegetable Curry',
                                    category: 'Veg',
                                    imageUrl: _getImageUrl('Vegetable Curry'),
                                    price: '\$13.00',
                                    rating: 4.4,
                                    quantity: '1 serving',
                                    description:
                                        'Mixed vegetables cooked in aromatic spices and coconut curry. Served with basmati rice and naan bread.',
                                  ),
                                ),
                              );
                            },
                          ),
                          // Salad Items
                          ProductCard(
                            imageUrl: _getImageUrl('Caesar Salad'),
                            title: 'Caesar Salad',
                            quantity: '1 serving',
                            currentPrice: '\$12',
                            originalPrice: '\$15',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Caesar Salad',
                                    category: 'Salads',
                                    imageUrl: _getImageUrl('Caesar Salad'),
                                    price: '\$12.00',
                                    rating: 4.6,
                                    quantity: '1 serving',
                                    description:
                                        'Fresh crisp romaine lettuce with homemade Caesar dressing, parmesan cheese, croutons, and grilled chicken. A classic favorite.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Greek Salad'),
                            title: 'Greek Salad',
                            quantity: '1 serving',
                            currentPrice: '\$11',
                            originalPrice: '\$14',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Greek Salad',
                                    category: 'Salads',
                                    imageUrl: _getImageUrl('Greek Salad'),
                                    price: '\$11.00',
                                    rating: 4.5,
                                    quantity: '1 serving',
                                    description:
                                        'Fresh tomatoes, cucumbers, red onions, olives, and feta cheese with Greek dressing. A Mediterranean classic.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Quinoa Salad'),
                            title: 'Quinoa Salad',
                            quantity: '1 serving',
                            currentPrice: '\$13',
                            originalPrice: '\$16',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Quinoa Salad',
                                    category: 'Salads',
                                    imageUrl: _getImageUrl('Quinoa Salad'),
                                    price: '\$13.00',
                                    rating: 4.7,
                                    quantity: '1 serving',
                                    description:
                                        'Nutritious quinoa mixed with fresh vegetables, herbs, and lemon vinaigrette. A healthy and satisfying option.',
                                  ),
                                ),
                              );
                            },
                          ),
                          // Dessert Items
                          ProductCard(
                            imageUrl: _getImageUrl('Chocolate Cake'),
                            title: 'Chocolate Cake',
                            quantity: '1 slice',
                            currentPrice: '\$8',
                            originalPrice: '\$10',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Chocolate Cake',
                                    category: 'Desserts',
                                    imageUrl: _getImageUrl('Chocolate Cake'),
                                    price: '\$8.00',
                                    rating: 4.8,
                                    quantity: '1 slice',
                                    description:
                                        'Rich and moist chocolate cake with creamy frosting. A decadent treat for chocolate lovers.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Tiramisu'),
                            title: 'Tiramisu',
                            quantity: '1 serving',
                            currentPrice: '\$9',
                            originalPrice: '\$12',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Tiramisu',
                                    category: 'Desserts',
                                    imageUrl: _getImageUrl('Tiramisu'),
                                    price: '\$9.00',
                                    rating: 4.9,
                                    quantity: '1 serving',
                                    description:
                                        'Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone cream. Topped with cocoa powder.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('New York Cheesecake'),
                            title: 'New York Cheesecake',
                            quantity: '1 slice',
                            currentPrice: '\$10',
                            originalPrice: '\$13',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'New York Cheesecake',
                                    category: 'Desserts',
                                    imageUrl: _getImageUrl('New York Cheesecake'),
                                    price: '\$10.00',
                                    rating: 4.7,
                                    quantity: '1 slice',
                                    description:
                                        'Creamy and rich cheesecake with a buttery graham cracker crust. Served with berry compote.',
                                  ),
                                ),
                              );
                            },
                          ),
                          // More Main Course
                          ProductCard(
                            imageUrl: _getImageUrl('Margherita Pizza'),
                            title: 'Margherita Pizza',
                            quantity: '1 large',
                            currentPrice: '\$20',
                            originalPrice: '\$24',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Margherita Pizza',
                                    category: 'Main Course',
                                    imageUrl: _getImageUrl('Margherita Pizza'),
                                    price: '\$20.00',
                                    rating: 4.8,
                                    quantity: '1 large',
                                    description:
                                        'Classic Margherita pizza with fresh mozzarella, basil, and tomato sauce. Baked to perfection in our wood-fired oven.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Classic Burger'),
                            title: 'Classic Burger',
                            quantity: '1 piece',
                            currentPrice: '\$12',
                            originalPrice: '\$15',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Classic Burger',
                                    category: 'Main Course',
                                    imageUrl: _getImageUrl('Classic Burger'),
                                    price: '\$12.00',
                                    rating: 4.7,
                                    quantity: '1 piece',
                                    description:
                                        'Juicy beef patty with fresh vegetables, special sauce, and a perfectly toasted bun. Served with crispy fries.',
                                  ),
                                ),
                              );
                            },
                          ),
                          // More Non-Veg
                          ProductCard(
                            imageUrl: _getImageUrl('Seafood Platter'),
                            title: 'Seafood Platter',
                            quantity: '1 serving',
                            currentPrice: '\$28',
                            originalPrice: '\$35',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Seafood Platter',
                                    category: 'Non-Veg',
                                    imageUrl: _getImageUrl('Seafood Platter'),
                                    price: '\$28.00',
                                    rating: 4.7,
                                    quantity: '1 serving',
                                    description:
                                        'Fresh selection of premium seafood including grilled fish, shrimp, and calamari. Served with lemon butter sauce and seasonal sides.',
                                  ),
                                ),
                              );
                            },
                          ),
                          // More Veg
                          ProductCard(
                            imageUrl: _getImageUrl('Veg Burger'),
                            title: 'Veg Burger',
                            quantity: '1 piece',
                            currentPrice: '\$11',
                            originalPrice: '\$14',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Veg Burger',
                                    category: 'Veg',
                                    imageUrl: _getImageUrl('Veg Burger'),
                                    price: '\$11.00',
                                    rating: 4.5,
                                    quantity: '1 piece',
                                    description:
                                        'Delicious vegetable patty made with fresh vegetables and spices, served with fresh lettuce, tomato, and special sauce.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Veg Wrap'),
                            title: 'Veg Wrap',
                            quantity: '1 piece',
                            currentPrice: '\$10',
                            originalPrice: '\$12',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Veg Wrap',
                                    category: 'Veg',
                                    imageUrl: _getImageUrl('Veg Wrap'),
                                    price: '\$10.00',
                                    rating: 4.4,
                                    quantity: '1 piece',
                                    description:
                                        'Fresh tortilla wrap filled with grilled vegetables, hummus, and fresh herbs. A healthy and satisfying vegetarian option.',
                                  ),
                                ),
                              );
                            },
                          ),
                          // More Salads
                          ProductCard(
                            imageUrl: _getImageUrl('Garden Salad'),
                            title: 'Garden Salad',
                            quantity: '1 serving',
                            currentPrice: '\$10',
                            originalPrice: '\$13',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Garden Salad',
                                    category: 'Salads',
                                    imageUrl: _getImageUrl('Garden Salad'),
                                    price: '\$10.00',
                                    rating: 4.5,
                                    quantity: '1 serving',
                                    description:
                                        'Fresh mixed greens with seasonal vegetables, cherry tomatoes, cucumbers, and your choice of dressing. Light and refreshing.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Fresh Fruit Salad'),
                            title: 'Fresh Fruit Salad',
                            quantity: '1 serving',
                            currentPrice: '\$9',
                            originalPrice: '\$12',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Fresh Fruit Salad',
                                    category: 'Salads',
                                    imageUrl: _getImageUrl('Fresh Fruit Salad'),
                                    price: '\$9.00',
                                    rating: 4.6,
                                    quantity: '1 serving',
                                    description:
                                        'Assortment of fresh seasonal fruits with a light honey-lime dressing. A healthy and refreshing dessert option.',
                                  ),
                                ),
                              );
                            },
                          ),
                          // More Desserts
                          ProductCard(
                            imageUrl: _getImageUrl('Ice Cream Sundae'),
                            title: 'Ice Cream Sundae',
                            quantity: '1 serving',
                            currentPrice: '\$7',
                            originalPrice: '\$9',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Ice Cream Sundae',
                                    category: 'Desserts',
                                    imageUrl: _getImageUrl('Ice Cream Sundae'),
                                    price: '\$7.00',
                                    rating: 4.6,
                                    quantity: '1 serving',
                                    description:
                                        'Vanilla ice cream topped with chocolate sauce, whipped cream, nuts, and a cherry. A classic dessert favorite.',
                                  ),
                                ),
                              );
                            },
                          ),
                          ProductCard(
                            imageUrl: _getImageUrl('Chocolate Brownie'),
                            title: 'Chocolate Brownie',
                            quantity: '1 piece',
                            currentPrice: '\$6',
                            originalPrice: '\$8',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Chocolate Brownie',
                                    category: 'Desserts',
                                    imageUrl: _getImageUrl('Chocolate Brownie'),
                                    price: '\$6.00',
                                    rating: 4.7,
                                    quantity: '1 piece',
                                    description:
                                        'Rich and fudgy chocolate brownie served warm with vanilla ice cream. A perfect ending to any meal.',
                                  ),
                                ),
                              );
                            },
                          ),
                          // Soup
                          ProductCard(
                            imageUrl: _getImageUrl('Creamy Soup'),
                            title: 'Creamy Soup',
                            quantity: '1 bowl',
                            currentPrice: '\$10',
                            originalPrice: '\$12',
                            isFavorite: false,
                            onFavoriteTap: () {
                              // Handle favorite tap
                            },
                            onAddTap: () {
                              // Handle add to cart
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productName: 'Creamy Soup',
                                    category: 'Main Course',
                                    imageUrl: _getImageUrl('Creamy Soup'),
                                    price: '\$10.00',
                                    rating: 4.5,
                                    quantity: '1 bowl',
                                    description:
                                        'Rich and creamy soup made with fresh ingredients, served hot with artisan bread. Perfect starter for any meal.',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Bottom padding to prevent overflow
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            CustomBottomNavBar(
              currentIndex: _currentNavIndex,
              cartItemCount: 3,
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
            ),
          ],
        ),
      ),
    );
  }
}
