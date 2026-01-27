import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/theme_helper.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/delivery_boy_provider.dart';

/// Bank Account Details Form Screen
class BankAccountFormScreen extends StatefulWidget {
  const BankAccountFormScreen({super.key});

  @override
  State<BankAccountFormScreen> createState() => _BankAccountFormScreenState();
}

class _BankAccountFormScreenState extends State<BankAccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountHolderNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _routingNumberController = TextEditingController();
  final _swiftCodeController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Load existing data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final documents = authProvider.deliveryBoyModel?.documents;
      if (documents != null && documents.containsKey('bankAccount')) {
        try {
          final bankAccountJson = documents['bankAccount']!;
          final bankAccountData = jsonDecode(bankAccountJson) as Map<String, dynamic>;
          _accountHolderNameController.text = bankAccountData['accountHolderName'] ?? '';
          _accountNumberController.text = bankAccountData['accountNumber'] ?? '';
          _bankNameController.text = bankAccountData['bankName'] ?? '';
          _routingNumberController.text = bankAccountData['routingNumber'] ?? '';
          _swiftCodeController.text = bankAccountData['swiftCode'] ?? '';
        } catch (e) {
          // If parsing fails, just leave fields empty
        }
      }
    });
  }

  @override
  void dispose() {
    _accountHolderNameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _routingNumberController.dispose();
    _swiftCodeController.dispose();
    super.dispose();
  }

  Future<void> _saveBankAccount() async {
    if (!_formKey.currentState!.validate()) {
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
      _isSaving = true;
    });

    try {
      // Create bank account details map
      final bankAccountDetails = {
        'accountHolderName': _accountHolderNameController.text.trim(),
        'accountNumber': _accountNumberController.text.trim(),
        'bankName': _bankNameController.text.trim(),
        'routingNumber': _routingNumberController.text.trim(),
        'swiftCode': _swiftCodeController.text.trim(),
      };

      // Update documents map
      final currentDocuments = Map<String, String>.from(
        authProvider.deliveryBoyModel!.documents ?? {},
      );
      // Store as JSON string in documents map
      currentDocuments['bankAccount'] = jsonEncode(bankAccountDetails);

      final updatedDeliveryBoy = authProvider.deliveryBoyModel!.copyWith(
        documents: currentDocuments,
      );

      final success = await deliveryBoyProvider.updateDeliveryBoy(updatedDeliveryBoy);

      if (success && mounted) {
        await authProvider.reloadUserData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bank account details saved successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(deliveryBoyProvider.error ?? 'Failed to save bank account details'),
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
          _isSaving = false;
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
          'Bank Account Details',
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
                // Account Holder Name
                _buildTextField(
                  controller: _accountHolderNameController,
                  labelText: 'Account Holder Name',
                  icon: Icons.person_outline,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter account holder name'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingM),
                // Account Number
                _buildTextField(
                  controller: _accountNumberController,
                  labelText: 'Account Number',
                  icon: Icons.account_balance,
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter account number'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingM),
                // Bank Name
                _buildTextField(
                  controller: _bankNameController,
                  labelText: 'Bank Name',
                  icon: Icons.account_balance_wallet,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter bank name'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingM),
                // Routing Number
                _buildTextField(
                  controller: _routingNumberController,
                  labelText: 'Routing Number',
                  icon: Icons.numbers,
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter routing number'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacingM),
                // SWIFT Code
                _buildTextField(
                  controller: _swiftCodeController,
                  labelText: 'SWIFT Code (Optional)',
                  icon: Icons.code,
                  validator: null,
                ),
                const SizedBox(height: AppTheme.spacingXL),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveBankAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                            ),
                          )
                        : const Text('Save Bank Account Details'),
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

