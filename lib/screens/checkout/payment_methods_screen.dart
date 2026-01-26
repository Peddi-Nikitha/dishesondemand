import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/payment_option_item.dart';
import 'payment_success_screen.dart';

/// Payment Methods screen for selecting payment method
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedPaymentMethod = 'Cash';

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
                    // Cash Section
                    _buildSectionTitle('Cash'),
                    const SizedBox(height: AppTheme.spacingM),
                    PaymentOptionItem(
                      icon: Icons.attach_money,
                      title: 'Cash',
                      isSelected: _selectedPaymentMethod == 'Cash',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Cash';
                        });
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Credit & Debit Card Section
                    _buildSectionTitle('Credit & Debit Card'),
                    const SizedBox(height: AppTheme.spacingM),
                    PaymentOptionItem(
                      icon: Icons.credit_card,
                      title: 'Add Card',
                      showArrow: true,
                      onTap: () {
                        // Handle add card
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add card feature coming soon'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // More Payment Options Section
                    _buildSectionTitle('More Payment Options'),
                    const SizedBox(height: AppTheme.spacingM),
                    PaymentOptionItem(
                      icon: Icons.payment,
                      title: 'Paypal',
                      isSelected: _selectedPaymentMethod == 'Paypal',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Paypal';
                        });
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    PaymentOptionItem(
                      icon: Icons.apple,
                      title: 'Apple Pay',
                      isSelected: _selectedPaymentMethod == 'Apple Pay',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Apple Pay';
                        });
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    PaymentOptionItem(
                      icon: Icons.account_balance_wallet,
                      title: 'Google Pay',
                      isSelected: _selectedPaymentMethod == 'Google Pay',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Google Pay';
                        });
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),
            // Confirm Payment Button
            _buildConfirmButton(),
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

  Widget _buildConfirmButton() {
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const PaymentSuccessScreen(),
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
}

