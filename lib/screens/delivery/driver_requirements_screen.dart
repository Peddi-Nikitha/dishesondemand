import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/driver_requirement_item.dart';
import '../../widgets/application_submitted_modal.dart';
import '../../providers/auth_provider.dart';
import '../../providers/delivery_boy_provider.dart';
import 'delivery_home_screen.dart';
import 'forms/profile_picture_form_screen.dart';
import 'forms/bank_account_form_screen.dart';
import 'forms/driving_details_form_screen.dart';
import 'forms/government_id_form_screen.dart';
import 'forms/car_information_form_screen.dart';

/// Driver Requirements screen matching the exact design from screenshot
class DriverRequirementsScreen extends StatefulWidget {
  const DriverRequirementsScreen({super.key});

  @override
  State<DriverRequirementsScreen> createState() => _DriverRequirementsScreenState();
}

class _DriverRequirementsScreenState extends State<DriverRequirementsScreen> {
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Reload delivery boy data when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        authProvider.reloadUserData();
      }
    });
  }

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
          'Driver Requirements',
          style: AppTextStyles.titleLarge.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer2<AuthProvider, DeliveryBoyProvider>(
          builder: (context, authProvider, deliveryBoyProvider, child) {
            final user = authProvider.user;
            final deliveryBoy = authProvider.deliveryBoyModel;
            
            // Get user name
            final userName = deliveryBoy?.name ?? user?.displayName ?? 'User';
            
            // Check document completion status
            final documents = deliveryBoy?.documents ?? {};
            final hasProfilePicture = deliveryBoy?.photoUrl != null;
            final hasBankDetails = documents.containsKey('bankAccount');
            final hasDrivingDetails = documents.containsKey('drivingLicense');
            final hasGovernmentId = documents.containsKey('governmentId');
            final hasCarInfo = documents.containsKey('vehicleRegistration') && 
                              deliveryBoy?.vehicleType != null && 
                              deliveryBoy?.vehicleNumber != null;

            if (_isUploading || authProvider.isLoading || deliveryBoyProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: Text(
                    'Welcome!, $userName',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Required Steps section
                        Text(
                          'Required Steps',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: ThemeHelper.getTextPrimaryColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        // Profile Picture
                        DriverRequirementItem(
                          title: 'Profile Picture',
                          isCompleted: hasProfilePicture,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProfilePictureFormScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        // Bank Account Details
                        DriverRequirementItem(
                          title: 'Bank Account Details',
                          isCompleted: hasBankDetails,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const BankAccountFormScreen(),
                              ),
                            );
                            // Reload data when returning from form
                            if (mounted && authProvider.user != null) {
                              await authProvider.reloadUserData();
                            }
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        // Driving Details
                        DriverRequirementItem(
                          title: 'Driving Details',
                          isCompleted: hasDrivingDetails,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DrivingDetailsFormScreen(),
                              ),
                            );
                            // Reload data when returning from form
                            if (mounted && authProvider.user != null) {
                              await authProvider.reloadUserData();
                            }
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                        // Submitted Steps section
                        Text(
                          'Submitted Steps',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: ThemeHelper.getTextPrimaryColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        // Government ID
                        DriverRequirementItem(
                          title: 'Government ID',
                          isCompleted: hasGovernmentId,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const GovernmentIdFormScreen(),
                              ),
                            );
                            // Reload data when returning from form
                            if (mounted && authProvider.user != null) {
                              await authProvider.reloadUserData();
                            }
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        // Car Information
                        DriverRequirementItem(
                          title: 'Car Information',
                          isCompleted: hasCarInfo,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CarInformationFormScreen(),
                              ),
                            );
                            // Reload data when returning from form
                            if (mounted && authProvider.user != null) {
                              await authProvider.reloadUserData();
                            }
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                      ],
                    ),
                  ),
                ),
                // Done button at bottom
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Show application submitted modal
                        ApplicationSubmittedModal.show(
                          context,
                          onGotIt: () {
                            // Navigate to delivery home screen after user acknowledges
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const DeliveryHomeScreen(),
                              ),
                            );
                          },
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
                        'Done',
                        style: AppTextStyles.buttonLarge,
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

}

