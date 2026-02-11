import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';

/// Help Center screen with FAQ and support information
class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

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
                    // Contact Support Section
                    _buildSection(
                      context,
                      title: 'Contact Support',
                      children: [
                        _buildContactItem(
                          context,
                          icon: Icons.email_outlined,
                          title: 'Email Support',
                          subtitle: 'support@curryfy.com',
                          onTap: () {
                            // Handle email tap
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildContactItem(
                          context,
                          icon: Icons.phone_outlined,
                          title: 'Phone Support',
                          subtitle: '+44 20 1234 5678',
                          onTap: () {
                            // Handle phone tap
                          },
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildContactItem(
                          context,
                          icon: Icons.chat_bubble_outline,
                          title: 'Live Chat',
                          subtitle: 'Available 24/7',
                          onTap: () {
                            // Handle live chat tap
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Frequently Asked Questions
                    _buildSection(
                      context,
                      title: 'Frequently Asked Questions',
                      children: [
                        _buildFAQItem(
                          context,
                          question: 'How do I place an order?',
                          answer: 'Browse our menu, add items to your cart, and proceed to checkout. You can select your delivery address and payment method during checkout.',
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildFAQItem(
                          context,
                          question: 'What payment methods do you accept?',
                          answer: 'We accept credit/debit cards, cash on delivery, and digital wallets. You can add multiple payment methods in your account settings.',
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildFAQItem(
                          context,
                          question: 'How long does delivery take?',
                          answer: 'Delivery typically takes 30-45 minutes depending on your location and order size. You can track your order in real-time once it\'s confirmed.',
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildFAQItem(
                          context,
                          question: 'Can I cancel my order?',
                          answer: 'Yes, you can cancel your order within 5 minutes of placing it. After that, please contact our support team for assistance.',
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildFAQItem(
                          context,
                          question: 'How do I track my order?',
                          answer: 'Go to "My Orders" in your account menu. You\'ll see all your orders with real-time tracking information and delivery status.',
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildFAQItem(
                          context,
                          question: 'What if I have dietary restrictions?',
                          answer: 'We offer vegetarian, vegan, and allergen-free options. Check product descriptions for detailed ingredient information and dietary labels.',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // App Information
                    _buildSection(
                      context,
                      title: 'App Information',
                      children: [
                        _buildInfoItem(
                          context,
                          label: 'App Version',
                          value: '1.0.0',
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        _buildInfoItem(
                          context,
                          label: 'Last Updated',
                          value: '2024',
                        ),
                      ],
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
            'Help Center',
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
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        ...children,
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: ThemeHelper.getSurfaceColor(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Icon(
                icon,
                color: ThemeHelper.getPrimaryColor(context),
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: ThemeHelper.getTextSecondaryColor(context),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTextStyles.bodyLarge.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            answer,
            style: AppTextStyles.bodyMedium.copyWith(
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

