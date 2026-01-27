import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/address_item.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import 'review_summary_screen.dart';
import 'add_address_screen.dart';

/// Delivery Address screen for selecting delivery address with Firestore integration
class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  AddressModel? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.userModel;
            final addresses = user?.addresses ?? [];

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
                        if (addresses.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppTheme.spacingXL),
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
                                    'Add an address to continue',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: ThemeHelper.getTextSecondaryColor(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...List.generate(
                            addresses.length,
                            (index) {
                              final address = addresses[index];
                              final isSelected = _selectedAddress?.id == address.id ||
                                  (_selectedAddress == null && address.isDefault);
                              
                              // Set default address as selected if none selected
                              if (_selectedAddress == null && address.isDefault) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (mounted) {
                                    setState(() {
                                      _selectedAddress = address;
                                    });
                                  }
                                });
                              }

                              return Column(
                                children: [
                                  AddressItem(
                                    title: address.label,
                                    address: _formatAddress(address),
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() {
                                        _selectedAddress = address;
                                      });
                                    },
                                    onEdit: () async {
                                      final result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AddAddressScreen(
                                            address: address,
                                          ),
                                        ),
                                      );
                                      if (result == true && mounted) {
                                        setState(() {
                                          // Force rebuild to show updated address
                                        });
                                      }
                                    },
                                    onDelete: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Delete Address',
                                            style: AppTextStyles.titleMedium.copyWith(
                                              color: ThemeHelper.getTextPrimaryColor(context),
                                            ),
                                          ),
                                          content: Text(
                                            'Are you sure you want to delete this address?',
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: ThemeHelper.getTextPrimaryColor(context),
                                            ),
                                          ),
                                          backgroundColor: ThemeHelper.getSurfaceColor(context),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text(
                                                'Cancel',
                                                style: AppTextStyles.buttonMedium.copyWith(
                                                  color: ThemeHelper.getTextSecondaryColor(context),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: Text(
                                                'Delete',
                                                style: AppTextStyles.buttonMedium.copyWith(
                                                  color: AppColors.error,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmed == true) {
                                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                        final success = await authProvider.deleteAddress(address.id);
                                        if (success && mounted) {
                                          // If deleted address was selected, clear selection
                                          if (_selectedAddress?.id == address.id) {
                                            setState(() {
                                              _selectedAddress = null;
                                            });
                                          }
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Address deleted successfully'),
                                              backgroundColor: AppColors.success,
                                            ),
                                          );
                                        } else if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error deleting address: ${authProvider.error ?? "Unknown error"}'),
                                              backgroundColor: AppColors.error,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  if (index < addresses.length - 1)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: AppTheme.spacingM,
                                      ),
                                      child: _buildDivider(),
                                    ),
                                ],
                              );
                            },
                          ),
                        const SizedBox(height: AppTheme.spacingL),
                        // Add New Address Button
                        _buildAddNewAddressButton(),
                        const SizedBox(height: AppTheme.spacingXL),
                      ],
                    ),
                  ),
                ),
                // Apply Button
                _buildApplyButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatAddress(AddressModel address) {
    return '${address.street}, ${address.city}, ${address.state} ${address.zipCode}, ${address.country}';
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
            'Delivery Address',
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

  Widget _buildAddNewAddressButton() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddAddressScreen(),
          ),
        );
        // Refresh addresses if a new one was added
        if (result == true && mounted) {
          setState(() {
            // Force rebuild to show new address
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingL,
          vertical: AppTheme.spacingM,
        ),
        decoration: BoxDecoration(
          color: ThemeHelper.getBackgroundColor(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacingS),
            Text(
              'Add New Delivery Address',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
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
            onPressed: _selectedAddress == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReviewSummaryScreen(
                          selectedAddress: _selectedAddress!,
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
              'Apply',
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
