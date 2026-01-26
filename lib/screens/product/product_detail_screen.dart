import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../models/menu_item.dart';

/// Product detail screen showing full product information
class ProductDetailScreen extends StatefulWidget {
  final String productName;
  final String category;
  final String imageUrl;
  final String price;
  final double rating;
  final String quantity;
  final String description;

  const ProductDetailScreen({
    super.key,
    required this.productName,
    required this.category,
    required this.imageUrl,
    required this.price,
    this.rating = 4.5,
    required this.quantity,
    required this.description,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;

  // Sample images for carousel
  final List<String> _productImages = [];

  @override
  void initState() {
    super.initState();
    // Add main image and additional images
    _productImages.add(widget.imageUrl);
    _productImages.add(widget.imageUrl); // Can add more images here
    _productImages.add(widget.imageUrl);
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  void _onImagePageChanged(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  double _getTotalPrice() {
    final priceValue = double.tryParse(widget.price.replaceAll('\$', '')) ?? 0.0;
    return priceValue * _quantity;
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
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Carousel
                    _buildImageCarousel(),
                    const SizedBox(height: AppTheme.spacingM),
                    // Product Information
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingL,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category
                          Text(
                            widget.category,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: ThemeHelper.getTextSecondaryColor(context),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Product Name and Quantity Selector Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.productName,
                                      style: AppTextStyles.headlineMedium.copyWith(
                                        color: ThemeHelper.getTextPrimaryColor(context),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Rating
                                    Row(
                                      children: [
                                        ...List.generate(5, (index) {
                                          if (index < widget.rating.floor()) {
                                            return Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 18,
                                            );
                                          } else if (index < widget.rating) {
                                            return Icon(
                                              Icons.star_half,
                                              color: Colors.amber,
                                              size: 18,
                                            );
                                          } else {
                                            return Icon(
                                              Icons.star_border,
                                              color: ThemeHelper.getTextSecondaryColor(context),
                                              size: 18,
                                            );
                                          }
                                        }),
                                        const SizedBox(width: 8),
                                        Text(
                                          '(${widget.rating})',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: AppColors.buttonPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity Selector
                              _buildQuantitySelector(),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingXL),
                          // Product Details Section
                          Text(
                            'Product Details',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          Text(
                            widget.description,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: ThemeHelper.getTextSecondaryColor(context),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXL),
                          // More Dishes Section
                          Text(
                            'More Dishes',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          _buildMoreProductsList(),
                          const SizedBox(height: 100), // Space for bottom bar
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Bar
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingM,
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
                color: ThemeHelper.getSurfaceColor(context),
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
            'Details',
            style: AppTextStyles.titleMedium.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          // Favorite Button
          GestureDetector(
            onTap: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getSurfaceColor(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite
                    ? AppColors.primary
                    : ThemeHelper.getTextPrimaryColor(context),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _imagePageController,
            onPageChanged: _onImagePageChanged,
            itemCount: _productImages.length,
            itemBuilder: (context, index) {
              return Image.network(
                _productImages[index],
                fit: BoxFit.contain,
                headers: const {
                  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                  'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ThemeHelper.getSurfaceColor(context),
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: ThemeHelper.getTextSecondaryColor(context),
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: ThemeHelper.getSurfaceColor(context),
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
              );
            },
          ),
          // Page Indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _productImages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _currentImageIndex ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == _currentImageIndex
                        ? AppColors.success
                        : (ThemeHelper.isDarkMode(context)
                            ? AppColors.darkDivider
                            : AppColors.divider),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus Button
          GestureDetector(
            onTap: _decreaseQuantity,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: ThemeHelper.getBackgroundColor(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove,
                color: ThemeHelper.getTextPrimaryColor(context),
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          // Quantity Text
          Text(
            '$_quantity',
            style: AppTextStyles.bodyLarge.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          // Plus Button
          GestureDetector(
            onTap: _increaseQuantity,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.buttonPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.textOnPrimary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          // Unit Text
          Text(
            widget.quantity.split(' ').last, // Extract unit (kg, ml, etc.)
            style: AppTextStyles.bodyMedium.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreProductsList() {
    // Helper function to get image URL from MenuData
    String _getImageUrl(String itemName) {
      final allItems = MenuData.allItems;
      final item = allItems.firstWhere(
        (item) => item.name == itemName,
        orElse: () => allItems.first,
      );
      return item.imageUrl;
    }

    final moreProducts = [
      {
        'image': _getImageUrl('Grilled Chicken'),
        'name': 'Grilled Chicken',
      },
      {
        'image': _getImageUrl('Premium Steak'),
        'name': 'Premium Steak',
      },
      {
        'image': _getImageUrl('Seafood Platter'),
        'name': 'Seafood Platter',
      },
      {
        'image': _getImageUrl('Margherita Pizza'),
        'name': 'Margherita Pizza',
      },
      {
        'image': _getImageUrl('Creamy Pasta'),
        'name': 'Creamy Pasta',
      },
      {
        'image': _getImageUrl('Caesar Salad'),
        'name': 'Caesar Salad',
      },
      {
        'image': _getImageUrl('Tiramisu'),
        'name': 'Tiramisu',
      },
      {
        'image': _getImageUrl('Chocolate Cake'),
        'name': 'Chocolate Cake',
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moreProducts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Get product data from MenuData
              final allItems = MenuData.allItems;
              final item = allItems.firstWhere(
                (item) => item.name == moreProducts[index]['name']!,
                orElse: () => allItems.first,
              );
              
              // Navigate to product detail
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    productName: item.name,
                    category: item.category,
                    imageUrl: item.imageUrl,
                    price: item.formattedCurrentPrice,
                    rating: item.rating,
                    quantity: item.quantity,
                    description: item.description,
                  ),
                ),
              );
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: AppTheme.spacingM),
              decoration: BoxDecoration(
                color: ThemeHelper.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(
                  color: ThemeHelper.getBorderColor(context),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                child: Image.network(
                  moreProducts[index]['image']!,
                  fit: BoxFit.cover,
                  headers: const {
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                    'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                  },
                  cacheWidth: 200,
                  cacheHeight: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: ThemeHelper.getSurfaceColor(context),
                      child: Icon(
                        Icons.image_not_supported,
                        color: ThemeHelper.getTextSecondaryColor(context),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        boxShadow: [
          BoxShadow(
            color: ThemeHelper.isDarkMode(context)
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Price',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: ThemeHelper.getTextSecondaryColor(context),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${_getTotalPrice().toStringAsFixed(2)}',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Add to Cart Button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  // Handle add to cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.productName} added to cart'),
                      backgroundColor: AppColors.buttonPrimary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add to Cart',
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

