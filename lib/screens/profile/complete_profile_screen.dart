import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../location/location_access_screen.dart';

/// Complete Profile screen with dark theme
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  File? _profileImage;
  String _selectedCountryCode = '+1';
  String? _selectedGender;
  final ImagePicker _picker = ImagePicker();

  final List<String> _countryCodes = ['+1', '+44', '+91', '+86', '+81', '+33'];
  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppTheme.spacingXL),
                // Title
                Text(
                  'Complete Your Profile',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingM),
                // Description
                Text(
                  'Don\'t worry. only you can see your personal data. No one else Will be able to see it.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingXL),
                // Profile Picture
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeHelper.getSurfaceColor(context),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: _profileImage != null
                            ? ClipOval(
                                child: Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.primary,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ThemeHelper.getBackgroundColor(context),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.textOnPrimary,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                // Phone Number
                Text(
                  'Phone Number',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Row(
                  children: [
                    // Country Code Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeHelper.getSurfaceColor(context),
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        border: Border.all(color: ThemeHelper.getBorderColor(context)),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        dropdownColor: ThemeHelper.getSurfaceColor(context),
                        underline: const SizedBox(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: ThemeHelper.getTextPrimaryColor(context),
                        ),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: ThemeHelper.getTextPrimaryColor(context),
                        ),
                        items: _countryCodes.map((code) {
                          return DropdownMenuItem(
                            value: code,
                            child: Text(code),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCountryCode = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    // Phone Input
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: 'Enter Phone Number',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: ThemeHelper.getTextSecondaryColor(context),
                          ),
                          filled: true,
                          fillColor: ThemeHelper.getSurfaceColor(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            borderSide: BorderSide(
                              color: ThemeHelper.getBorderColor(context),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            borderSide: BorderSide(
                              color: ThemeHelper.getBorderColor(context),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: ThemeHelper.getTextPrimaryColor(context),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingL),
                // Gender
                Text(
                  'Gender',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Container(
                  decoration: BoxDecoration(
                    color: ThemeHelper.getSurfaceColor(context),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    border: Border.all(color: ThemeHelper.getBorderColor(context)),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: ThemeHelper.getTextPrimaryColor(context),
                        ),
                      ),
                      textTheme: Theme.of(context).textTheme.copyWith(
                        bodyLarge: TextStyle(
                          color: ThemeHelper.getTextPrimaryColor(context),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      dropdownColor: ThemeHelper.getSurfaceColor(context),
                      decoration: InputDecoration(
                        hintText: 'Select',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                          vertical: AppTheme.spacingM,
                        ),
                      ),
                      style: TextStyle(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return _genders.map((gender) {
                          return Text(
                            gender,
                            style: TextStyle(
                              color: ThemeHelper.getTextPrimaryColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          );
                        }).toList();
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: ThemeHelper.getTextPrimaryColor(context),
                      ),
                      iconEnabledColor: ThemeHelper.getTextPrimaryColor(context),
                      iconDisabledColor: ThemeHelper.getTextSecondaryColor(context),
                      items: _genders.map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(
                            gender,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                // Complete Profile Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LocationAccessScreen(),
                          ),
                        );
                      }
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
                      'Complete Profile',
                      style: AppTextStyles.buttonLarge,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

