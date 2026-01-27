import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';

/// Detailed view for a single customer in the Supermarket (Admin) module.
class CustomerDetailsScreen extends StatelessWidget {
  final UserModel customer;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.darkSurface : const Color(0xFF2A2A2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Customer Details',
          style: AppTextStyles.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: AppTheme.spacingL),
            _buildInfoCards(context),
            const SizedBox(height: AppTheme.spacingL),
            _buildAddressesSection(context),
            const SizedBox(height: AppTheme.spacingL),
            _buildPaymentMethodsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          child: customer.photoUrl != null && customer.photoUrl!.isNotEmpty
              ? Image.network(
                  customer.photoUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[800],
                      child: Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: 40,
                      ),
                    );
                  },
                )
              : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[800],
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: 40,
                  ),
                ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer.name ?? 'No Name',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                customer.email,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[300],
                ),
              ),
              if (customer.phone != null && customer.phone!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  customer.phone!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Text(
                  customer.role.toUpperCase(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    final createdAt =
        '${customer.createdAt.day}/${customer.createdAt.month}/${customer.createdAt.year}';
    final updatedAt =
        '${customer.updatedAt.day}/${customer.updatedAt.month}/${customer.updatedAt.year}';

    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            title: 'Customer ID',
            value: '#${customer.uid.substring(0, 8)}',
            icon: Icons.badge,
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: _buildInfoCard(
            context,
            title: 'Joined',
            value: createdAt,
            icon: Icons.event_available,
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: _buildInfoCard(
            context,
            title: 'Last Updated',
            value: updatedAt,
            icon: Icons.update,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.isDarkMode(context)
            ? AppColors.darkSurface
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesSection(BuildContext context) {
    return _buildSectionContainer(
      context,
      title: 'Addresses',
      icon: Icons.location_on,
      child: customer.addresses.isEmpty
          ? Text(
              'No addresses on file.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[400],
              ),
            )
          : Column(
              children: customer.addresses
                  .map(
                    (address) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppTheme.spacingS,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            address.isDefault
                                ? Icons.star
                                : Icons.location_pin,
                            color: address.isDefault
                                ? AppColors.primary
                                : Colors.grey[500],
                            size: 20,
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.label,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${address.street}, ${address.city}, ${address.state} ${address.zipCode}',
                                  style:
                                      AppTextStyles.bodySmall.copyWith(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  address.country,
                                  style:
                                      AppTextStyles.bodySmall.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _buildPaymentMethodsSection(BuildContext context) {
    return _buildSectionContainer(
      context,
      title: 'Payment Methods',
      icon: Icons.payment,
      child: customer.paymentMethods.isEmpty
          ? Text(
              'No saved payment methods.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[400],
              ),
            )
          : Column(
              children: customer.paymentMethods
                  .map(
                    (pm) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppTheme.spacingS,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            pm.type == 'card'
                                ? Icons.credit_card
                                : pm.type == 'wallet'
                                    ? Icons.account_balance_wallet
                                    : Icons.monetization_on,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatPaymentTitle(pm),
                                  style:
                                      AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (pm.last4 != null &&
                                    pm.last4!.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '**** **** **** ${pm.last4}',
                                    style: AppTextStyles.bodySmall
                                        .copyWith(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (pm.isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingS,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusS,
                                ),
                              ),
                              child: Text(
                                'DEFAULT',
                                style:
                                    AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _buildSectionContainer(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.isDarkMode(context)
            ? AppColors.darkSurface
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          child,
        ],
      ),
    );
  }

  String _formatPaymentTitle(PaymentMethodModel pm) {
    if (pm.type == 'card') {
      final brand = pm.brand != null && pm.brand!.isNotEmpty
          ? pm.brand!.toUpperCase()
          : 'CARD';
      return brand;
    }
    if (pm.type == 'wallet') {
      return 'WALLET';
    }
    return 'CASH';
  }
}


