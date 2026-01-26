import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/cart_item_card.dart';
import 'payment_methods_screen.dart';
import '../../models/menu_item.dart';

/// Review Summary screen showing order details and summary
class ReviewSummaryScreen extends StatefulWidget {
  const ReviewSummaryScreen({super.key});

  @override
  State<ReviewSummaryScreen> createState() => _ReviewSummaryScreenState();
}

class _ReviewSummaryScreenState extends State<ReviewSummaryScreen> {
  int _pizzaQuantity = 1;
  int _pastaQuantity = 1;

  // Helper method to get image URL from MenuData
  static String _getImageUrl(String itemName) {
    final allItems = MenuData.allItems;
    final item = allItems.firstWhere(
      (item) => item.name == itemName,
      orElse: () => allItems.first,
    );
    return item.imageUrl;
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
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dish List
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
                    const SizedBox(height: AppTheme.spacingM),
                    // Order Information Section
                    _buildDivider(),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildOrderInfoRow('Order Date', 'Des 18, 2025 | 10:00 AM'),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildOrderInfoRow('Promo code', 'FR1254HGGWE'),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildOrderInfoRow('Expected Delivery Date', 'Des 19, 2025'),
                    const SizedBox(height: AppTheme.spacingM),
                    // Price Breakdown Section
                    _buildDivider(),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildPriceRow('Sub Total:', '\$66.00'),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildPriceRow('Shipping:', '\$10.00'),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildPriceRow('Tax:', '\$00.00'),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildPriceRow('Discount:', '10%'),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildDivider(),
                    const SizedBox(height: AppTheme.spacingM),
                    _buildTotalRow('Total Amount:', '\$68.40'),
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),
            // Download Button
            _buildDownloadButton(),
          ],
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

  Widget _buildDownloadButton() {
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PaymentMethodsScreen(),
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
              'Download E-Receipt',
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

