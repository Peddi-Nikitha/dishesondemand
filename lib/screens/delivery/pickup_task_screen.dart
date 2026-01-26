import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/pickup_location_card.dart';
import '../../widgets/contact_info_card.dart';

/// Pickup task screen with map and information panel
class PickupTaskScreen extends StatelessWidget {
  const PickupTaskScreen({super.key});

  // Profile image URL
  static const String profileImageUrl =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Map section (top 2/3)
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  // Map background (using a placeholder image)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: ThemeHelper.getSurfaceColor(context),
                    ),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
                      fit: BoxFit.cover,
                      headers: const {
                        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: ThemeHelper.getSurfaceColor(context),
                          child: Center(
                            child: Icon(
                              Icons.map,
                              size: 100,
                              color: ThemeHelper.getTextSecondaryColor(context),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Map markers overlay
                  _buildMapMarkers(context),
                ],
              ),
            ),
            // Information panel (bottom 1/3)
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingL,
                  AppTheme.spacingL,
                  AppTheme.spacingL,
                  AppTheme.spacingM,
                ),
                decoration: BoxDecoration(
                  color: ThemeHelper.getBackgroundColor(context),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.radiusXL),
                    topRight: Radius.circular(AppTheme.radiusXL),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with distance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Going to Pick Up',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: ThemeHelper.getTextPrimaryColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            '5.5 KM Away',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: ThemeHelper.getPrimaryColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      // Pickup location card
                      PickupLocationCard(
                        address: '4 Sultan Bello, Agric, IKE). Lagos. Nigeria.',
                        icon: Icons.shopping_cart,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      // Contact info card
                      ContactInfoCard(
                        profileImageUrl: profileImageUrl,
                        name: 'Mohamed Tarek',
                        phoneNumber: '+201090229396',
                        onCallTap: () {
                          // Handle call
                        },
                        onChatTap: () {
                          // Handle chat
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      // I've arrived button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle arrived
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
                            "I've arrived",
                            style: AppTextStyles.buttonLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMarkers(BuildContext context) {
    return Stack(
      children: [
        // Pickup location marker (yellow house icon - using orange in our theme)
        Positioned(
          top: 80,
          right: 60,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.home,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ThemeHelper.getSurfaceColor(context),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '4 Sultan Bello, Agric, IKD, Lagos...',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Current location marker (green pin with person icon)
        Positioned(
          bottom: 200,
          left: 40,
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.textOnPrimary,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        // Vehicle location marker (white car icon)
        Positioned(
          bottom: 150,
          right: 120,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: ThemeHelper.getSurfaceColor(context),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.directions_car,
              color: ThemeHelper.getTextPrimaryColor(context),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

