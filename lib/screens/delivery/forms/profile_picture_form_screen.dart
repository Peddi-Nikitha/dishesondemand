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

/// Profile Picture Upload Screen
class ProfilePictureFormScreen extends StatefulWidget {
  const ProfilePictureFormScreen({super.key});

  @override
  State<ProfilePictureFormScreen> createState() => _ProfilePictureFormScreenState();
}

class _ProfilePictureFormScreenState extends State<ProfilePictureFormScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final StorageService _storageService = StorageService();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
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

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
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

  Future<void> _saveProfilePicture() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
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
      // Upload image to Firebase Storage
      final photoUrl = await _storageService.uploadUserProfileImage(
        _selectedImage!,
        authProvider.user!.uid,
      );

      // Update delivery boy document
      final updatedDeliveryBoy = authProvider.deliveryBoyModel!.copyWith(
        photoUrl: photoUrl,
      );

      final success = await deliveryBoyProvider.updateDeliveryBoy(updatedDeliveryBoy);

      if (success && mounted) {
        // Reload auth provider to get updated data
        await authProvider.reloadUserData();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture uploaded successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(deliveryBoyProvider.error ?? 'Failed to upload profile picture'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading: $e'),
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
          'Profile Picture',
          style: AppTextStyles.titleLarge.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final currentPhotoUrl = authProvider.deliveryBoyModel?.photoUrl;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppTheme.spacingM),
                  // Current or Selected Image
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: ThemeHelper.getSurfaceColor(context),
                          backgroundImage: (!kIsWeb && _selectedImage != null)
                              ? FileImage(_selectedImage!)
                              : (currentPhotoUrl != null
                                  ? NetworkImage(currentPhotoUrl)
                                  : null),
                          child: _selectedImage == null && currentPhotoUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: 80,
                                  color: ThemeHelper.getTextSecondaryColor(context),
                                )
                              : null,
                        ),
                        if (_selectedImage != null)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ThemeHelper.getBackgroundColor(context),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: AppColors.textOnPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXL),
                  // Pick from Gallery Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isUploading ? null : _pickImage,
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
                      onPressed: _isUploading ? null : _takePhoto,
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
                      onPressed: (_selectedImage != null && !_isUploading) ? _saveProfilePicture : null,
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
                          : const Text('Save Profile Picture'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

