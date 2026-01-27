import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../utils/constants.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import '../delivery/delivery_home_screen.dart';
import '../supermarket/supermarket_dashboard_screen.dart';
import 'splash_data.dart';
import 'splash_page.dart';
import '../welcome/welcome_screen.dart';

/// Main splash screen with PageView, indicators, and navigation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < SplashScreenData.totalScreens - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  void _skipToHome() {
    _navigateToHome();
  }

  void _navigateToHome() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // If user is already authenticated, navigate based on role
    if (authProvider.isAuthenticated && authProvider.userRole != null) {
      final role = authProvider.userRole;

      Widget target;
      if (role == AppConstants.roleUser) {
        target = const HomeScreen();
      } else if (role == AppConstants.roleDeliveryBoy) {
        target = const DeliveryHomeScreen();
      } else if (role == AppConstants.roleAdmin) {
        target = const SupermarketDashboardScreen();
      } else {
        target = const WelcomeScreen();
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => target),
      );
    } else {
      // No authenticated user -> go to onboarding / welcome
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: TextButton(
                  onPressed: _skipToHome,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.skipButton.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                    ),
                  ),
                ),
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: SplashScreenData.totalScreens,
                itemBuilder: (context, index) {
                  return SplashPage(
                    data: SplashScreenData.splashScreens[index],
                  );
                },
              ),
            ),
            // Page Indicators and Next Button
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      SplashScreenData.totalScreens,
                      (index) => _buildPageIndicator(index == _currentPage),
                    ),
                  ),
                  // Next/Get Started Button
                  _buildNextButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.indicatorActive
            : (ThemeHelper.isDarkMode(context) 
                ? AppColors.darkDivider 
                : AppColors.indicatorInactive),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildNextButton() {
    final bool isLastPage = _currentPage == SplashScreenData.totalScreens - 1;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.buttonPrimary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ThemeHelper.isDarkMode(context)
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _nextPage,
          borderRadius: BorderRadius.circular(28),
          child: Center(
            child: Icon(
              isLastPage ? Icons.check : Icons.arrow_forward,
              color: AppColors.textOnPrimary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

