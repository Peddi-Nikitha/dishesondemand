import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../providers/auth_provider.dart';
import '../supermarket/supermarket_dashboard_screen.dart';
import '../../utils/constants.dart';

/// Supermarket Dashboard (POS System) Login Screen
/// Matches the design with orange theme instead of green
class SupermarketLoginScreen extends StatefulWidget {
  const SupermarketLoginScreen({super.key});

  @override
  State<SupermarketLoginScreen> createState() => _SupermarketLoginScreenState();
}

class _SupermarketLoginScreenState extends State<SupermarketLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: '••••••••');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final stripeWidth = screenWidth * 0.35; // 35% of screen width

    return Scaffold(
      backgroundColor: ThemeHelper.isDarkMode(context)
          ? AppColors.darkBackground
          : const Color(0xFF2A2A2A), // Dark gray background
      body: Stack(
        children: [
          // Orange vertical stripe on the left
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: stripeWidth,
            child: Container(
              color: AppColors.primary, // Orange stripe
            ),
          ),
          // Main content area
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  margin: EdgeInsets.only(left: stripeWidth * 0.3),
                  padding: const EdgeInsets.all(AppTheme.spacingXXL),
                  decoration: BoxDecoration(
                    color: ThemeHelper.isDarkMode(context)
                        ? AppColors.darkSurface
                        : const Color(0xFFE8E8E8), // Light gray background
                    borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo Circle Background (behind logo)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: ThemeHelper.isDarkMode(context)
                                    ? AppColors.darkDivider
                                    : const Color(0xFFD0D0D0),
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Marketox Logo
                            _buildLogo(),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingL),
                        const SizedBox(height: AppTheme.spacingXL),
                        // Illustration
                        _buildIllustration(),
                        const SizedBox(height: AppTheme.spacingXL),
                        // LOGIN Heading
                        Text(
                          'LOGIN',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: ThemeHelper.getTextPrimaryColor(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        // Description text
                        Text(
                          'Enter any information, then click Login Now.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: ThemeHelper.getTextSecondaryColor(context),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This is a trial version',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: ThemeHelper.getTextSecondaryColor(context),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                        // Username Field
                        _buildUsernameField(),
                        const SizedBox(height: AppTheme.spacingL),
                        // Password Field
                        _buildPasswordField(),
                        const SizedBox(height: AppTheme.spacingXL),
                        // Login Now Button
                        _buildLoginButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.headlineLarge.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'Market',
            style: AppTextStyles.headlineLarge.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primary, // Orange
            ),
          ),
          TextSpan(
            text: 'ox',
            style: AppTextStyles.headlineLarge.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: ThemeHelper.isDarkMode(context)
                  ? AppColors.darkTextPrimary
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3), // Blue background
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Stack(
        children: [
          // Person at desk illustration
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Person with laptop
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Books stack on left
                    Column(
                      children: [
                        Container(
                          width: 20,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 20,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Person
                    Container(
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Laptop
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.laptop,
                        size: 24,
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Plant
                    Container(
                      width: 15,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Desk
                Container(
                  width: 180,
                  height: 4,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
          // Floating icons around
          Positioned(
            left: 20,
            top: 30,
            child: _buildFloatingIcon(Icons.settings, const Color(0xFF90CAF9)),
          ),
          Positioned(
            right: 20,
            top: 30,
            child: _buildFloatingIcon(Icons.send, Colors.white),
          ),
          Positioned(
            left: 30,
            bottom: 40,
            child: _buildFloatingIcon(Icons.chat_bubble_outline, Colors.white),
          ),
          Positioned(
            right: 30,
            bottom: 40,
            child: _buildFloatingIcon(Icons.person_outline, const Color(0xFF90CAF9)),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: _buildFloatingIcon(Icons.web, Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 18,
        color: color,
      ),
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: AppTextStyles.labelSmall.copyWith(
            color: ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'admin',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: ThemeHelper.isDarkMode(context)
                  ? AppColors.darkTextSecondary
                  : Colors.white,
            ),
            filled: true,
            fillColor: ThemeHelper.isDarkMode(context)
                ? AppColors.darkDivider
                : const Color(0xFF3A3A3A), // Dark gray field
            prefixIcon: Icon(
              Icons.person_outline,
              color: ThemeHelper.getTextSecondaryColor(context),
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingM,
            ),
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.isDarkMode(context)
                ? AppColors.darkTextPrimary
                : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: AppTextStyles.labelSmall.copyWith(
            color: ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: ThemeHelper.isDarkMode(context)
                  ? AppColors.darkTextSecondary
                  : Colors.white,
              letterSpacing: 2,
            ),
            filled: true,
            fillColor: ThemeHelper.isDarkMode(context)
                ? AppColors.darkDivider
                : const Color(0xFF3A3A3A), // Dark gray field
            prefixIcon: Icon(
              Icons.lock_outline,
              color: ThemeHelper.getTextSecondaryColor(context),
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: ThemeHelper.getTextSecondaryColor(context),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingM,
            ),
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.isDarkMode(context)
                ? AppColors.darkTextPrimary
                : Colors.white,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            final success = await authProvider.signIn(
              email: _usernameController.text.trim(),
              password: _passwordController.text,
            );

            if (success && context.mounted) {
              // Verify admin role
              final role = authProvider.userRole;
              if (role == AppConstants.roleAdmin) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SupermarketDashboardScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Access denied. Admin credentials required.'),
                    backgroundColor: AppColors.error,
                  ),
                );
                await authProvider.signOut();
              }
            } else if (context.mounted && authProvider.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authProvider.error!),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Orange button
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          elevation: 0,
        ),
        child: Text(
          'Login Now',
          style: AppTextStyles.buttonLarge.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

