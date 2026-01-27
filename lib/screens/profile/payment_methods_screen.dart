import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/payment_option_item.dart';
import '../../providers/auth_provider.dart';

/// Payment Methods Management Screen
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payment Methods',
          style: AppTextStyles.titleLarge.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final paymentMethods = authProvider.userModel?.paymentMethods ?? [];

            if (authProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cash Section
                        _buildSectionTitle(context, 'Cash'),
                        const SizedBox(height: AppTheme.spacingM),
                        PaymentOptionItem(
                          icon: Icons.attach_money,
                          title: 'Cash on Delivery',
                          isSelected: false,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cash on Delivery is always available'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                        // Saved Cards Section
                        _buildSectionTitle(context, 'Credit & Debit Cards'),
                        const SizedBox(height: AppTheme.spacingM),
                        if (paymentMethods.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingL),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.credit_card_off,
                                    size: 64,
                                    color: ThemeHelper.getTextSecondaryColor(context),
                                  ),
                                  const SizedBox(height: AppTheme.spacingM),
                                  Text(
                                    'No saved cards',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: ThemeHelper.getTextSecondaryColor(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...paymentMethods.map((method) {
                            if (method.type == 'Card') {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                                child: PaymentOptionItem(
                                  icon: Icons.credit_card,
                                  title: method.last4 != null 
                                      ? 'Card ending in ${method.last4}'
                                      : 'Card',
                                  isSelected: method.isDefault,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Card management feature coming soon'),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }).toList(),
                        PaymentOptionItem(
                          icon: Icons.add_card,
                          title: 'Add New Card',
                          showArrow: true,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Add new card feature coming soon'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                        // More Payment Options Section
                        _buildSectionTitle(context, 'More Payment Options'),
                        const SizedBox(height: AppTheme.spacingM),
                        PaymentOptionItem(
                          icon: Icons.payment,
                          title: 'PayPal',
                          isSelected: false,
                          onTap: () {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('PayPal integration coming soon'),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        PaymentOptionItem(
                          icon: Icons.apple,
                          title: 'Apple Pay',
                          isSelected: false,
                          onTap: () {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Apple Pay integration coming soon'),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        PaymentOptionItem(
                          icon: Icons.account_balance_wallet,
                          title: 'Google Pay',
                          isSelected: false,
                          onTap: () {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Google Pay integration coming soon'),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        color: ThemeHelper.getTextPrimaryColor(context),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

