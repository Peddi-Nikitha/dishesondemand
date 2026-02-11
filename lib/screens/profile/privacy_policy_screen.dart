import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';

/// Privacy Policy screen with privacy policy content
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy Policy',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      'Last Updated: January 2024',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: ThemeHelper.getTextSecondaryColor(context),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    _buildSection(
                      context,
                      title: '1. Information We Collect',
                      content: 'We collect information that you provide directly to us, including:\n\n'
                          '• Name, email address, phone number, and delivery address\n'
                          '• Payment information (processed securely through our payment partners)\n'
                          '• Order history and preferences\n'
                          '• Device information and location data (with your permission)\n'
                          '• Usage data and app interactions',
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildSection(
                      context,
                      title: '2. How We Use Your Information',
                      content: 'We use the information we collect to:\n\n'
                          '• Process and deliver your orders\n'
                          '• Communicate with you about your orders and account\n'
                          '• Improve our services and user experience\n'
                          '• Send you promotional offers (with your consent)\n'
                          '• Ensure security and prevent fraud\n'
                          '• Comply with legal obligations',
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildSection(
                      context,
                      title: '3. Information Sharing',
                      content: 'We do not sell your personal information. We may share your information with:\n\n'
                          '• Delivery partners to fulfill your orders\n'
                          '• Payment processors to handle transactions\n'
                          '• Service providers who assist in our operations\n'
                          '• Legal authorities when required by law',
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildSection(
                      context,
                      title: '4. Data Security',
                      content: 'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet is 100% secure. We use encryption and secure protocols to safeguard your data.',
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildSection(
                      context,
                      title: '5. Your Rights',
                      content: 'You have the right to:\n\n'
                          '• Access your personal information\n'
                          '• Correct inaccurate information\n'
                          '• Request deletion of your data\n'
                          '• Opt-out of marketing communications\n'
                          '• Withdraw consent for data processing',
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildSection(
                      context,
                      title: '6. Cookies and Tracking',
                      content: 'We use cookies and similar technologies to enhance your experience, analyze usage, and personalize content. You can manage cookie preferences in your device settings.',
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildSection(
                      context,
                      title: '7. Children\'s Privacy',
                      content: 'Our services are not intended for children under 13. We do not knowingly collect personal information from children under 13.',
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildSection(
                      context,
                      title: '8. Changes to This Policy',
                      content: 'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last Updated" date.',
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildSection(
                      context,
                      title: '9. Contact Us',
                      content: 'If you have questions about this Privacy Policy, please contact us at:\n\n'
                          'Email: privacy@curryfy.com\n'
                          'Phone: +44 20 1234 5678\n'
                          'Address: Curryfy Ltd, London, United Kingdom',
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getBackgroundColor(context),
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
          Text(
            'Privacy Policy',
            style: AppTextStyles.titleLarge.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleSmall.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          content,
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.getTextSecondaryColor(context),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

