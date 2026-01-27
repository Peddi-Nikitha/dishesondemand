import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../providers/delivery_boy_provider.dart';
import '../../models/delivery_boy_model.dart';
import '../../utils/constants.dart';

/// Delivery Boy Management Screen for Admin
class DeliveryBoyManagementScreen extends StatefulWidget {
  const DeliveryBoyManagementScreen({super.key});

  @override
  State<DeliveryBoyManagementScreen> createState() => _DeliveryBoyManagementScreenState();
}

class _DeliveryBoyManagementScreenState extends State<DeliveryBoyManagementScreen> {
  String _selectedStatus = 'all'; // 'all', 'active', 'inactive', 'pending'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deliveryBoyProvider = Provider.of<DeliveryBoyProvider>(context, listen: false);
      deliveryBoyProvider.loadDeliveryBoys();
    });
  }

  void _filterByStatus(String status) {
    setState(() {
      _selectedStatus = status;
    });
    final deliveryBoyProvider = Provider.of<DeliveryBoyProvider>(context, listen: false);
    if (status == 'all') {
      deliveryBoyProvider.loadDeliveryBoys();
    } else {
      deliveryBoyProvider.loadDeliveryBoysByStatus(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryBoyProvider>(
      builder: (context, deliveryBoyProvider, _) {
        if (deliveryBoyProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (deliveryBoyProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  deliveryBoyProvider.error!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                ElevatedButton(
                  onPressed: () {
                    _filterByStatus(_selectedStatus);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final deliveryBoys = deliveryBoyProvider.deliveryBoys;

        return Column(
          children: [
            // Header with Filters
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Boys (${deliveryBoys.length})',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  // Status Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'all'),
                        const SizedBox(width: AppTheme.spacingS),
                        _buildFilterChip('Active', AppConstants.deliveryBoyStatusActive),
                        const SizedBox(width: AppTheme.spacingS),
                        _buildFilterChip('Inactive', AppConstants.deliveryBoyStatusInactive),
                        const SizedBox(width: AppTheme.spacingS),
                        _buildFilterChip('Pending', AppConstants.deliveryBoyStatusPending),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Delivery Boys List
            Expanded(
              child: deliveryBoys.isEmpty
                  ? Center(
                      child: Text(
                        'No delivery boys found',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                      ),
                      itemCount: deliveryBoys.length,
                      itemBuilder: (context, index) {
                        final deliveryBoy = deliveryBoys[index];
                        return _buildDeliveryBoyCard(deliveryBoy, deliveryBoyProvider);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String status) {
    final isSelected = _selectedStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _filterByStatus(status);
        }
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.textOnPrimary : Colors.white,
      ),
    );
  }

  Widget _buildDeliveryBoyCard(DeliveryBoyModel deliveryBoy, DeliveryBoyProvider provider) {
    Color statusColor;
    switch (deliveryBoy.status) {
      case AppConstants.deliveryBoyStatusActive:
        statusColor = AppColors.success;
        break;
      case AppConstants.deliveryBoyStatusInactive:
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.warning;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      color: ThemeHelper.isDarkMode(context)
          ? AppColors.darkSurface
          : const Color(0xFF2A2A2A),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          backgroundImage: deliveryBoy.photoUrl != null
              ? NetworkImage(deliveryBoy.photoUrl!)
              : null,
          child: deliveryBoy.photoUrl == null
              ? Text(
                  deliveryBoy.name?.isNotEmpty == true
                      ? deliveryBoy.name![0].toUpperCase()
                      : 'D',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                )
              : null,
        ),
        title: Text(
          deliveryBoy.name ?? 'No Name',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deliveryBoy.email,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey[400],
              ),
            ),
            if (deliveryBoy.phone != null)
              Text(
                deliveryBoy.phone!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[400],
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Text(
                    deliveryBoy.status.toUpperCase(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                if (deliveryBoy.rating > 0)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        deliveryBoy.rating.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (deliveryBoy.status == AppConstants.deliveryBoyStatusPending)
              IconButton(
                icon: const Icon(Icons.check_circle, color: AppColors.success),
                onPressed: () => _activateDeliveryBoy(deliveryBoy, provider),
                tooltip: 'Activate',
              ),
            if (deliveryBoy.status == AppConstants.deliveryBoyStatusActive)
              IconButton(
                icon: const Icon(Icons.block, color: AppColors.error),
                onPressed: () => _deactivateDeliveryBoy(deliveryBoy, provider),
                tooltip: 'Deactivate',
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: () => _deleteDeliveryBoy(deliveryBoy, provider),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _activateDeliveryBoy(DeliveryBoyModel deliveryBoy, DeliveryBoyProvider provider) async {
    final success = await provider.updateDeliveryBoyStatus(
      deliveryBoy.uid,
      AppConstants.deliveryBoyStatusActive,
      true,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Delivery boy activated successfully'
                : provider.error ?? 'Failed to activate delivery boy',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  Future<void> _deactivateDeliveryBoy(DeliveryBoyModel deliveryBoy, DeliveryBoyProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Delivery Boy'),
        content: Text('Are you sure you want to deactivate "${deliveryBoy.name ?? deliveryBoy.email}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await provider.updateDeliveryBoyStatus(
        deliveryBoy.uid,
        AppConstants.deliveryBoyStatusInactive,
        false,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Delivery boy deactivated successfully'
                  : provider.error ?? 'Failed to deactivate delivery boy',
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteDeliveryBoy(DeliveryBoyModel deliveryBoy, DeliveryBoyProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Delivery Boy'),
        content: Text('Are you sure you want to delete "${deliveryBoy.name ?? deliveryBoy.email}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await provider.deleteDeliveryBoy(deliveryBoy.uid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Delivery boy deleted successfully'
                  : provider.error ?? 'Failed to delete delivery boy',
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }
}

