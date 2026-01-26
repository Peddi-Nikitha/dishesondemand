import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';
import '../utils/theme_helper.dart';

/// Reusable success animation widget with animated checkmark and decorative elements
class SuccessAnimation extends StatefulWidget {
  const SuccessAnimation({super.key});

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _rotationController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _checkScaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Rotation animation controller (continuous)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    // Scale animation for outer circle
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    
    // Fade animation for decorative elements
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );
    
    // Checkmark scale animation
    _checkScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.9, curve: Curves.elasticOut),
      ),
    );
    
    // Rotation animation for decorative elements
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      _rotationController,
    );
    
    // Particle animation
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.easeOut,
      ),
    );
    
    // Start animations
    _mainController.forward();
    _particleController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _particleController,
          _rotationController,
        ]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Animated particles
              ...List.generate(12, (index) {
                final angle = (index * 30) * math.pi / 180;
                final distance = 80.0 + (_particleAnimation.value * 40);
                final x = math.cos(angle + _rotationAnimation.value * 0.5) * distance;
                final y = math.sin(angle + _rotationAnimation.value * 0.5) * distance;
                final opacity = (1.0 - _particleAnimation.value) * _fadeAnimation.value;
                
                return Positioned(
                  left: 100 + x - 6,
                  top: 100 + y - 6,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              
              // Outer decorative circles and shapes
              ...List.generate(8, (index) {
                final angle = (index * 45) * math.pi / 180;
                final radius = 70.0;
                final rotation = _rotationAnimation.value * 0.3;
                final x = radius * math.cos(angle + rotation);
                final y = radius * math.sin(angle + rotation);
                
                return Positioned(
                  left: 100 + x - 8,
                  top: 100 + y - 8,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: ThemeHelper.isDarkMode(context)
                              ? AppColors.primary.withValues(alpha: 0.4)
                              : AppColors.primary.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              
              // Medium decorative shapes
              ...List.generate(4, (index) {
                final angle = (index * 90) * math.pi / 180;
                final radius = 50.0;
                final rotation = _rotationAnimation.value * 0.2;
                final x = radius * math.cos(angle + rotation);
                final y = radius * math.sin(angle + rotation);
                
                return Positioned(
                  left: 100 + x - 15,
                  top: 100 + y - 15,
                  child: Opacity(
                    opacity: _fadeAnimation.value * 0.7,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value * 0.5,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              
              // Outer white circle with scale animation
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Inner circle with checkmark
              Transform.scale(
                scale: _checkScaleAnimation.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ThemeHelper.isDarkMode(context)
                        ? AppColors.darkBackground
                        : AppColors.textPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: ThemeHelper.isDarkMode(context)
                          ? AppColors.darkTextPrimary
                          : AppColors.background,
                      size: 60,
                      weight: 3,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

