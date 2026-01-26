import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/cart_item_card.dart';
import '../../widgets/promo_code_input.dart';
import '../../widgets/order_summary.dart';
import '../checkout/delivery_address_screen.dart';
import '../../models/menu_item.dart';

/// Production-ready shopping cart screen matching the exact design
class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final TextEditingController _promoCodeController = TextEditingController();
  
  // Dish quantities
  int _pastaQuantity = 1;
  int _pizzaQuantity = 1;
  int _burgerQuantity = 1;
  int _saladQuantity = 1;

  // Helper method to get image URL from MenuData
  String _getImageUrl(String itemName) {
    final allItems = MenuData.allItems;
    final item = allItems.firstWhere(
      (item) => item.name == itemName,
      orElse: () => allItems.first,
    );
    return item.imageUrl;
  }

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
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
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product List
                    CartItemCard(
                      imageUrl: _getImageUrl('Creamy Pasta'),
                      title: 'Creamy Pasta',
                      quantity: '1 serving',
                      currentPrice: '\$15',
                      originalPrice: '\$18',
                      discountBadge: '35% OFF',
                      itemQuantity: _pastaQuantity,
                      onRemove: () {
                        // Handle remove
                      },
                      onDecrease: () {
                        if (_pastaQuantity > 1) {
                          setState(() {
                            _pastaQuantity--;
                          });
                        }
                      },
                      onIncrease: () {
                        setState(() {
                          _pastaQuantity++;
                        });
                      },
                    ),
                    CartItemCard(
                      imageUrl: _getImageUrl('Margherita Pizza'),
                      title: 'Margherita Pizza',
                      quantity: '1 large',
                      currentPrice: '\$20',
                      originalPrice: '\$24',
                      discountBadge: '35% OFF',
                      itemQuantity: _pizzaQuantity,
                      onRemove: () {
                        // Handle remove
                      },
                      onDecrease: () {
                        if (_pizzaQuantity > 1) {
                          setState(() {
                            _pizzaQuantity--;
                          });
                        }
                      },
                      onIncrease: () {
                        setState(() {
                          _pizzaQuantity++;
                        });
                      },
                    ),
                    CartItemCard(
                      imageUrl: _getImageUrl('Classic Burger'),
                      title: 'Classic Burger',
                      quantity: '1 piece',
                      currentPrice: '\$12',
                      originalPrice: '\$15',
                      discountBadge: '35% OFF',
                      itemQuantity: _burgerQuantity,
                      onRemove: () {
                        // Handle remove
                      },
                      onDecrease: () {
                        if (_burgerQuantity > 1) {
                          setState(() {
                            _burgerQuantity--;
                          });
                        }
                      },
                      onIncrease: () {
                        setState(() {
                          _burgerQuantity++;
                        });
                      },
                    ),
                    CartItemCard(
                      imageUrl: _getImageUrl('Caesar Salad'),
                      title: 'Caesar Salad',
                      quantity: '1 serving',
                      currentPrice: '\$12',
                      originalPrice: '\$15',
                      discountBadge: '35% OFF',
                      itemQuantity: _saladQuantity,
                      onRemove: () {
                        // Handle remove
                      },
                      onDecrease: () {
                        if (_saladQuantity > 1) {
                          setState(() {
                            _saladQuantity--;
                          });
                        }
                      },
                      onIncrease: () {
                        setState(() {
                          _saladQuantity++;
                        });
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    // Promo Code Section
                    PromoCodeInput(
                      controller: _promoCodeController,
                      onApply: () {
                        // Handle apply promo code
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    // Order Summary
                    OrderSummary(
                      subTotal: '\$66.00',
                      shipping: '\$10.00',
                      discount: '10%',
                      totalAmount: '\$68.40',
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),
            // Checkout Button
            _buildCheckoutButton(),
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
            'Shopping Cart',
            style: AppTextStyles.titleLarge.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.getBackgroundColor(context),
        boxShadow: [
          BoxShadow(
            color: ThemeHelper.isDarkMode(context)
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DeliveryAddressScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeHelper.getPrimaryColor(context),
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            elevation: 0,
          ),
          child: Text(
            'Proceed to Checkout',
            style: AppTextStyles.buttonLarge,
          ),
        ),
      ),
    );
  }
}

