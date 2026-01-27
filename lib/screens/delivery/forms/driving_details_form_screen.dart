import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/theme_helper.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/delivery_boy_provider.dart';
import '../../../services/storage_service.dart';

/// Driving Details Form Screen with License Upload
class DrivingDetailsFormScreen extends StatefulWidget {
  const DrivingDetailsFormScreen({super.key});

  @override
  State<DrivingDetailsFormScreen> createState() => _DrivingDetailsFormScreenState();
}

class _DrivingDetailsFormScreenState extends State<DrivingDetailsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  final StorageService _storageService = StorageService();
  final _licenseNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  File? _licenseImage;
  bool _isUploading = false;

  @override
  void dispose() {
    _licenseNumberController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _pickLicenseImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _licenseImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _takeLicensePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _licenseImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _saveDrivingDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_licenseImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload your driving license'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // File uploads using dart:io are not supported on Flutter Web
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document upload is not supported on web. Please run on Android or iOS.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final deliveryBoyProvider = Provider.of<DeliveryBoyProvider>(context, listen: false);

    if (authProvider.user == null || authProvider.deliveryBoyModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not authenticated'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload license image
      final licenseUrl = await _storageService.uploadDeliveryBoyDocument(
        file: _licenseImage!,
        deliveryBoyId: authProvider.user!.uid,
        documentType: 'license',
      );

      // Update documents map
      final currentDocuments = Map<String, String>.from(
        authProvider.deliveryBoyModel!.documents ?? {},
      );
      currentDocuments['drivingLicense'] = licenseUrl;
      currentDocuments['licenseNumber'] = _licenseNumberController.text.trim();
      currentDocuments['licenseExpiry'] = _expiryDateController.text.trim();

      final updatedDeliveryBoy = authProvider.deliveryBoyModel!.copyWith(
        documents: currentDocuments,
      );

      final success = await deliveryBoyProvider.updateDeliveryBoy(updatedDeliveryBoy);

      if (success && mounted) {
        await authProvider.reloadUserData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driving details saved successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(deliveryBoyProvider.error ?? 'Failed to save driving details'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
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
          'Driving Details',
          style: AppTextStyles.titleLarge.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppTheme.spacingM),
                // License Number
                _buildTextField(
                  controller: _licenseNumberController,
                  labelText: 'License Number',
                  icon: Icons.credit_card,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter license number'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingM),
                // Expiry Date
                _buildTextField(
                  controller: _expiryDateController,
                  labelText: 'Expiry Date (MM/YYYY)',
                  icon: Icons.calendar_today,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter expiry date'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingL),
                // License Image Upload
                Text(
                  'Upload Driving License',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                // License Image Preview
                if (_licenseImage != null)
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(
                        color: ThemeHelper.getBorderColor(context),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      child: kIsWeb
                          ? Center(
                              child: Text(
                                'Image preview not supported on web.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: ThemeHelper.getTextSecondaryColor(context),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Image.file(
                              _licenseImage!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                // Pick from Gallery Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isUploading ? null : _pickLicenseImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choose from Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeHelper.getSurfaceColor(context),
                      foregroundColor: ThemeHelper.getTextPrimaryColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        side: BorderSide(
                          color: ThemeHelper.getBorderColor(context),
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                // Take Photo Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isUploading ? null : _takeLicensePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeHelper.getSurfaceColor(context),
                      foregroundColor: ThemeHelper.getTextPrimaryColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        side: BorderSide(
                          color: ThemeHelper.getBorderColor(context),
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _saveDrivingDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      elevation: 0,
                    ),
                    child: _isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                            ),
                          )
                        : const Text('Save Driving Details'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(
          icon,
          color: ThemeHelper.getTextSecondaryColor(context),
        ),
        filled: true,
        fillColor: ThemeHelper.getSurfaceColor(context),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: ThemeHelper.getTextSecondaryColor(context),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: BorderSide(
            color: ThemeHelper.getBorderColor(context),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: BorderSide(
            color: ThemeHelper.getBorderColor(context),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingM,
        ),
      ),
      style: AppTextStyles.bodyLarge.copyWith(
        color: ThemeHelper.getTextPrimaryColor(context),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

