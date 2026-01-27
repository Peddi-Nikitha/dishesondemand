import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/payment_option_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/user_model.dart';
import '../../models/order_model.dart';
import '../../utils/constants.dart';
import 'payment_success_screen.dart';

/// Payment Methods screen for selecting payment method with Firestore integration
class PaymentMethodsScreen extends StatefulWidget {
  final AddressModel selectedAddress;

  const PaymentMethodsScreen({
    super.key,
    required this.selectedAddress,
  });

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  PaymentMethodModel? _selectedPaymentMethod;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Consumer3<AuthProvider, CartProvider, OrderProvider>(
          builder: (context, authProvider, cartProvider, orderProvider, child) {
            final user = authProvider.userModel;
            final paymentMethods = user?.paymentMethods ?? [];

            // Set default payment method if none selected
            if (_selectedPaymentMethod == null && paymentMethods.isNotEmpty) {
              final defaultMethod = paymentMethods.firstWhere(
                (pm) => pm.isDefault,
                orElse: () => paymentMethods.first,
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _selectedPaymentMethod = defaultMethod;
                  });
                }
              });
            }

            return Column(
              children: [
                // Header
                _buildHeader(),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cash Section
                        _buildSectionTitle('Cash'),
                        const SizedBox(height: AppTheme.spacingM),
                        PaymentOptionItem(
                          icon: Icons.attach_money,
                          title: 'Cash',
                          isSelected: _selectedPaymentMethod?.type == 'cash',
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = PaymentMethodModel(
                                id: 'cash',
                                type: 'cash',
                              );
                            });
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                        // Credit & Debit Card Section
                        _buildSectionTitle('Credit & Debit Card'),
                        const SizedBox(height: AppTheme.spacingM),
                        if (paymentMethods.where((pm) => pm.type == 'card').isEmpty)
                          PaymentOptionItem(
                            icon: Icons.credit_card,
                            title: 'Add Card',
                            showArrow: true,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Add card feature coming soon'),
                                ),
                              );
                            },
                          )
                        else
                          ...paymentMethods.where((pm) => pm.type == 'card').map((pm) {
                            final cardTitle = pm.brand != null && pm.last4 != null
                                ? '${pm.brand!.toUpperCase()} •••• ${pm.last4}'
                                : 'Card';
                            return PaymentOptionItem(
                              icon: Icons.credit_card,
                              title: cardTitle,
                              isSelected: _selectedPaymentMethod?.id == pm.id,
                              onTap: () {
                                setState(() {
                                  _selectedPaymentMethod = pm;
                                });
                              },
                            );
                          }),
                        const SizedBox(height: AppTheme.spacingXL),
                        // More Payment Options Section
                        _buildSectionTitle('More Payment Options'),
                        const SizedBox(height: AppTheme.spacingM),
                        PaymentOptionItem(
                          icon: Icons.payment,
                          title: 'Paypal',
                          isSelected: _selectedPaymentMethod?.type == 'paypal',
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = PaymentMethodModel(
                                id: 'paypal',
                                type: 'paypal',
                              );
                            });
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        PaymentOptionItem(
                          icon: Icons.apple,
                          title: 'Apple Pay',
                          isSelected: _selectedPaymentMethod?.type == 'apple_pay',
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = PaymentMethodModel(
                                id: 'apple_pay',
                                type: 'apple_pay',
                              );
                            });
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        PaymentOptionItem(
                          icon: Icons.account_balance_wallet,
                          title: 'Google Pay',
                          isSelected: _selectedPaymentMethod?.type == 'google_pay',
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = PaymentMethodModel(
                                id: 'google_pay',
                                type: 'google_pay',
                              );
                            });
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                      ],
                    ),
                  ),
                ),
                // Confirm Payment Button
                _buildConfirmButton(authProvider, cartProvider, orderProvider),
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
        color: ThemeHelper.getBackgroundColor(context),
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
            'Payment Methods',
            style: AppTextStyles.titleLarge.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        color: ThemeHelper.getTextPrimaryColor(context),
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    );
  }

  Widget _buildConfirmButton(
    AuthProvider authProvider,
    CartProvider cartProvider,
    OrderProvider orderProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.getBackgroundColor(context),
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
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: (_isProcessing || _selectedPaymentMethod == null || cartProvider.items.isEmpty)
                ? null
                : () => _handleConfirmPayment(authProvider, cartProvider, orderProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeHelper.getPrimaryColor(context),
              foregroundColor: AppColors.textOnPrimary,
              disabledBackgroundColor: ThemeHelper.getTextSecondaryColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              elevation: 0,
            ),
            child: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                    ),
                  )
                : Text(
                    'Confirm Payment',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleConfirmPayment(
    AuthProvider authProvider,
    CartProvider cartProvider,
    OrderProvider orderProvider,
  ) async {
    if (authProvider.user == null || _selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Generate order number
      final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      // Convert cart items to order items
      final orderItems = cartProvider.items.map((cartItem) {
        return OrderItemModel(
          productId: cartItem.productId,
          productName: cartItem.product.name,
          quantity: cartItem.quantity,
          price: cartItem.product.currentPrice,
          imageUrl: cartItem.product.imageUrl,
        );
      }).toList();

      // Create order
      final order = OrderModel(
        id: '', // Will be set by repository
        userId: authProvider.user!.uid,
        orderNumber: orderNumber,
        items: orderItems,
        subtotal: cartProvider.subtotal,
        deliveryFee: cartProvider.shipping,
        discount: cartProvider.discount,
        total: cartProvider.total,
        status: AppConstants.orderStatusPending,
        deliveryAddress: widget.selectedAddress,
        paymentMethod: _selectedPaymentMethod!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create order in Firestore
      await orderProvider.createOrder(order);

      // Clear cart locally and remotely
      await cartProvider.clearCart(clearRemote: true);

      // Navigate to success screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const PaymentSuccessScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating order: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
