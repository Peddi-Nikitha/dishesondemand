import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/cart_item_card.dart';
import '../../widgets/promo_code_input.dart';
import '../../widgets/order_summary.dart';
import '../checkout/delivery_address_screen.dart';
import '../../providers/cart_provider.dart';

/// Production-ready shopping cart screen with Firestore integration
class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final TextEditingController _promoCodeController = TextEditingController();

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  String _calculateDiscountPercentage(CartProvider cartProvider) {
    if (cartProvider.subtotal > 0 && cartProvider.discount > 0) {
      return '${cartProvider.discountPercentage.toStringAsFixed(0)}%';
    }
    return '0%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            if (cartProvider.items.isEmpty) {
              return Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: ThemeHelper.getTextSecondaryColor(context),
                          ),
                          const SizedBox(height: AppTheme.spacingL),
                          Text(
                            'Your cart is empty',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            'Add some items to get started',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: ThemeHelper.getTextSecondaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
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
                        ...cartProvider.items.map((cartItem) {
                          final product = cartItem.product;
                          final discountPercent = product.originalPrice != null &&
                                  product.originalPrice! > product.currentPrice
                              ? ((product.originalPrice! - product.currentPrice) /
                                      product.originalPrice! *
                                      100)
                                  .toStringAsFixed(0)
                              : '0';
                          
                          return CartItemCard(
                            imageUrl: product.imageUrl,
                            title: product.name,
                            quantity: product.quantity,
                            currentPrice: product.formattedCurrentPrice,
                            originalPrice: product.formattedOriginalPrice,
                            discountBadge: discountPercent != '0' ? '$discountPercent% OFF' : '',
                            itemQuantity: cartItem.quantity,
                            onRemove: () {
                              cartProvider.removeItem(product.id);
                            },
                            onDecrease: () {
                              cartProvider.decreaseQuantity(product.id);
                            },
                            onIncrease: () {
                              cartProvider.increaseQuantity(product.id);
                            },
                          );
                        }).toList(),
                        const SizedBox(height: AppTheme.spacingM),
                        // Promo Code Section
                        PromoCodeInput(
                          controller: _promoCodeController,
                          onApply: () {
                            if (_promoCodeController.text.isNotEmpty) {
                              cartProvider.applyPromoCode(_promoCodeController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Promo code applied: ${_promoCodeController.text}'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        // Order Summary
                        OrderSummary(
                          subTotal: '£${cartProvider.subtotal.toStringAsFixed(2)}',
                          shipping: '£${cartProvider.shipping.toStringAsFixed(2)}',
                          discount: _calculateDiscountPercentage(cartProvider),
                          totalAmount: '£${cartProvider.total.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                      ],
                    ),
                  ),
                ),
                // Checkout Button
                _buildCheckoutButton(cartProvider),
              ],
            );
          },
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

  Widget _buildCheckoutButton(CartProvider cartProvider) {
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
          onPressed: cartProvider.items.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DeliveryAddressScreen(),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeHelper.getPrimaryColor(context),
            foregroundColor: AppColors.textOnPrimary,
            disabledBackgroundColor: ThemeHelper.getTextSecondaryColor(context),
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
