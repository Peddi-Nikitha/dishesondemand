import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/address_item.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../checkout/add_address_screen.dart';

/// Addresses Management Screen
class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

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
          'My Addresses',
          style: AppTextStyles.titleLarge.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final addresses = authProvider.userModel?.addresses ?? [];

            if (authProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: addresses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 64,
                                color: ThemeHelper.getTextSecondaryColor(context),
                              ),
                              const SizedBox(height: AppTheme.spacingL),
                              Text(
                                'No addresses found',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: ThemeHelper.getTextPrimaryColor(context),
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingS),
                              Text(
                                'Add an address to get started',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: ThemeHelper.getTextSecondaryColor(context),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          child: Column(
                            children: [
                              ...List.generate(
                                addresses.length,
                                (index) {
                                  final address = addresses[index];
                                  return Column(
                                    children: [
                                      AddressItem(
                                        title: address.label,
                                        address: _formatAddress(address),
                                        isSelected: address.isDefault,
                                        onEdit: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AddAddressScreen(address: address),
                                            ),
                                          );
                                        },
                                        onDelete: () => _confirmDelete(context, authProvider, address.id),
                                      ),
                                      if (index < addresses.length - 1)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: AppTheme.spacingM,
                                          ),
                                          child: _buildDivider(context),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: AppTheme.spacingXL),
                            ],
                          ),
                        ),
                ),
                // Add New Address Button
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: ThemeHelper.getSurfaceColor(context),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
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
                              builder: (context) => const AddAddressScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add New Address',
                          style: AppTextStyles.buttonLarge.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  String _formatAddress(AddressModel address) {
    return '${address.street}, ${address.city}, ${address.state}, ${address.zipCode}, ${address.country}';
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: ThemeHelper.getBorderColor(context),
    );
  }

  Future<void> _confirmDelete(BuildContext context, AuthProvider authProvider, String addressId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final success = await authProvider.deleteAddress(addressId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address deleted successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? 'Failed to delete address'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}

