import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/cart_item_card.dart';
import '../../providers/cart_provider.dart';
import '../../models/user_model.dart';
import 'payment_methods_screen.dart';

/// Review Summary screen showing order details and summary with Firestore integration
class ReviewSummaryScreen extends StatefulWidget {
  final AddressModel selectedAddress;

  const ReviewSummaryScreen({
    super.key,
    required this.selectedAddress,
  });

  @override
  State<ReviewSummaryScreen> createState() => _ReviewSummaryScreenState();
}

class _ReviewSummaryScreenState extends State<ReviewSummaryScreen> {
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
                      child: Text(
                        'Cart is empty',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            final now = DateTime.now();
            final orderDate = '${_getMonthName(now.month)} ${now.day}, ${now.year} | ${_formatTime(now)}';
            final expectedDelivery = now.add(const Duration(days: 1));
            final expectedDeliveryDate = '${_getMonthName(expectedDelivery.month)} ${expectedDelivery.day}, ${expectedDelivery.year}';

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
                        // Cart Items List
                        ...cartProvider.items.map((cartItem) {
                          final product = cartItem.product;
                          final discountPercent = product.originalPrice != null &&
                                  product.originalPrice! > product.currentPrice
                              ? ((product.originalPrice! - product.currentPrice) /
                                      product.originalPrice! *
                                      100)
                                  .toStringAsFixed(0)
                              : '0';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                            child: CartItemCard(
                              imageUrl: product.imageUrl,
                              title: product.name,
                              quantity: product.quantity,
                              currentPrice: product.formattedCurrentPrice,
                              originalPrice: product.formattedOriginalPrice,
                              discountBadge: discountPercent != '0' ? '$discountPercent% OFF' : '',
                              itemQuantity: cartItem.quantity,
                              onRemove: () {
                                cartProvider.removeItem(cartItem.productId);
                              },
                              onDecrease: () {
                                cartProvider.decreaseQuantity(cartItem.productId);
                              },
                              onIncrease: () {
                                cartProvider.increaseQuantity(cartItem.productId);
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: AppTheme.spacingM),
                        // Order Information Section
                        _buildDivider(),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildOrderInfoRow('Order Date', orderDate),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildOrderInfoRow('Expected Delivery Date', expectedDeliveryDate),
                        const SizedBox(height: AppTheme.spacingM),
                        // Price Breakdown Section
                        _buildDivider(),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildPriceRow('Sub Total:', '£${cartProvider.subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildPriceRow('Shipping:', '£${cartProvider.shipping.toStringAsFixed(2)}'),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildPriceRow('Tax:', '£0.00'),
                        const SizedBox(height: AppTheme.spacingM),
                        if (cartProvider.discount > 0)
                          _buildPriceRow('Discount:', '${cartProvider.discountPercentage.toStringAsFixed(0)}%'),
                        if (cartProvider.discount > 0) const SizedBox(height: AppTheme.spacingM),
                        _buildDivider(),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildTotalRow('Total Amount:', '£${cartProvider.total.toStringAsFixed(2)}'),
                        const SizedBox(height: AppTheme.spacingXL),
                      ],
                    ),
                  ),
                ),
                // Download Button
                _buildDownloadButton(cartProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
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
            'Review Summary',
            style: AppTextStyles.titleLarge.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return CustomPaint(
      painter: _DashedLinePainter(
        color: ThemeHelper.isDarkMode(context)
            ? AppColors.darkDivider
            : AppColors.divider,
      ),
      child: const SizedBox(
        height: 1,
        width: double.infinity,
      ),
    );
  }

  Widget _buildOrderInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.titleMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadButton(CartProvider cartProvider) {
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
            onPressed: cartProvider.items.isEmpty
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PaymentMethodsScreen(
                          selectedAddress: widget.selectedAddress,
                        ),
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
              'Continue to Payment',
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
}

/// Custom painter for dashed line divider
class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
