import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../auth/create_account_screen.dart';
import '../auth/sign_in_screen.dart';

/// Welcome screen with restaurant image and call-to-action
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Top section with image (60% of screen)
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  // Background with pattern
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ThemeHelper.getBackgroundColor(context),
                    ),
                    child: CustomPaint(
                      painter: _PatternPainter(context),
                      child: Container(),
                    ),
                  ),
                  // Main image
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Image.asset(
                        'Untitled design - chef.PNG',
                        height: MediaQuery.of(context).size.height * 0.5,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Floating icons
                  Positioned(
                    top: 40,
                    left: 24,
                    child: _buildFloatingIcon(context, Icons.location_on),
                  ),
                  Positioned(
                    top: 40,
                    right: 24,
                    child: _buildFloatingIcon(context, Icons.delivery_dining),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 24,
                    child: _buildFloatingIcon(context, Icons.chat_bubble_outline),
                  ),
                  Positioned(
                    bottom: 100,
                    right: 24,
                    child: _buildFloatingIcon(context, Icons.restaurant),
                  ),
                ],
              ),
            ),
            // Bottom section with text and button (40% of screen)
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Headline with highlighted text
                    _buildHeadline(context),
                    const SizedBox(height: AppTheme.spacingM),
                    // Body text
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: ThemeHelper.getTextSecondaryColor(context),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Get Started button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreateAccountScreen(),
                            ),
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
                          "Let's Get Started",
                          style: AppTextStyles.buttonLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    // Sign In link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Already have an account? ',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: ThemeHelper.getTextSecondaryColor(context),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: ThemeHelper.getPrimaryColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadline(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.headlineMedium.copyWith(
          color: ThemeHelper.getTextPrimaryColor(context),
        ),
        children: [
          const TextSpan(text: "Let's find the "),
          TextSpan(
            text: 'Best',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const TextSpan(text: ' & '),
          TextSpan(
            text: 'Tasty Food',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(BuildContext context, IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ThemeHelper.isDarkMode(context)
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }
}

/// Custom painter for background pattern
class _PatternPainter extends CustomPainter {
  final BuildContext context;
  
  _PatternPainter(this.context);
  
  @override
  void paint(Canvas canvas, Size size) {
    final isDark = ThemeHelper.isDarkMode(context);
    final paint = Paint()
      ..color = (isDark ? AppColors.darkDivider : AppColors.divider)
          .withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw food-related icons as simple line art
    final icons = [
      Icons.set_meal,
      Icons.local_dining,
      Icons.shopping_basket,
      Icons.restaurant_menu,
      Icons.fastfood,
      Icons.cake,
      Icons.local_grocery_store,
    ];

    final spacing = size.width / 8;
    final iconSize = 24.0;

    for (int i = 0; i < icons.length; i++) {
      final x = spacing * (i + 1);
      final y = size.height * 0.3 + (i % 2) * 60;
      // Simple circle representation for icons
      canvas.drawCircle(
        Offset(x, y),
        iconSize / 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

