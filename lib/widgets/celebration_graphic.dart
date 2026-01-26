import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/theme_helper.dart';

/// Celebratory graphic widget for delivery completion with animations
class CelebrationGraphic extends StatefulWidget {
  const CelebrationGraphic({super.key});

  @override
  State<CelebrationGraphic> createState() => _CelebrationGraphicState();
}

class _CelebrationGraphicState extends State<CelebrationGraphic>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Rotation animation
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear,
      ),
    );
    
    // Scale animation (initial pop)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );
    
    // Pulse animation for the main circle
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start animations
    _scaleController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = ThemeHelper.getPrimaryColor(context);
    
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationAnimation,
        _scaleAnimation,
        _pulseAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159 * 0.1, // Slow rotation
            child: CustomPaint(
              size: const Size(200, 200),
              painter: _CelebrationPainter(
                primaryColor: primaryColor,
                isDarkMode: isDarkMode,
                pulseScale: _pulseAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CelebrationPainter extends CustomPainter {
  final Color primaryColor;
  final bool isDarkMode;
  final double pulseScale;

  _CelebrationPainter({
    required this.primaryColor,
    required this.isDarkMode,
    this.pulseScale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Main black circle with white diamond (with pulse effect)
    final mainCirclePaint = Paint()
      ..color = isDarkMode ? AppColors.darkSurface : AppColors.textPrimary
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 60 * pulseScale, mainCirclePaint);
    
    // Outer glow effect
    final glowPaint = Paint()
      ..color = (isDarkMode ? AppColors.darkSurface : AppColors.textPrimary)
          .withValues(alpha: 0.3 * pulseScale)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 70 * pulseScale, glowPaint);
    
    // White diamond in center
    final diamondPath = Path()
      ..moveTo(center.dx, center.dy - 15)
      ..lineTo(center.dx + 15, center.dy)
      ..lineTo(center.dx, center.dy + 15)
      ..lineTo(center.dx - 15, center.dy)
      ..close();
    
    final diamondPaint = Paint()
      ..color = isDarkMode ? AppColors.darkTextPrimary : AppColors.textOnPrimary
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(diamondPath, diamondPaint);
    
    // Surrounding shapes - rounded rectangles
    final rectPaint = Paint()
      ..color = isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary
      ..style = PaintingStyle.fill;
    
    // Top shapes
    final topRect1 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - 80, center.dy - 50),
        width: 40,
        height: 8,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(topRect1, rectPaint);
    
    final topRect2 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 70, center.dy - 60),
        width: 30,
        height: 6,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(topRect2, rectPaint);
    
    // Right shapes
    final rightRect1 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 90, center.dy),
        width: 35,
        height: 7,
      ),
      const Radius.circular(3.5),
    );
    canvas.drawRRect(rightRect1, rectPaint);
    
    final rightRect2 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 75, center.dy + 50),
        width: 25,
        height: 5,
      ),
      const Radius.circular(2.5),
    );
    canvas.drawRRect(rightRect2, rectPaint);
    
    // Bottom shapes
    final bottomRect1 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - 60, center.dy + 70),
        width: 45,
        height: 8,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(bottomRect1, rectPaint);
    
    final bottomRect2 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 50, center.dy + 75),
        width: 20,
        height: 6,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(bottomRect2, rectPaint);
    
    // Left shapes
    final leftRect1 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - 85, center.dy + 20),
        width: 30,
        height: 6,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(leftRect1, rectPaint);
    
    // Small white circles
    final circlePaint = Paint()
      ..color = isDarkMode ? AppColors.darkTextPrimary : AppColors.textOnPrimary
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(center.dx - 100, center.dy - 30), 4, circlePaint);
    canvas.drawCircle(Offset(center.dx + 110, center.dy - 40), 3, circlePaint);
    canvas.drawCircle(Offset(center.dx + 100, center.dy + 60), 4, circlePaint);
    canvas.drawCircle(Offset(center.dx - 70, center.dy + 80), 3, circlePaint);
    
    // Plus signs
    final plusPaint = Paint()
      ..color = isDarkMode ? AppColors.darkTextPrimary : AppColors.textOnPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Plus sign 1
    canvas.drawLine(
      Offset(center.dx - 50, center.dy - 80),
      Offset(center.dx - 50, center.dy - 70),
      plusPaint,
    );
    canvas.drawLine(
      Offset(center.dx - 55, center.dy - 75),
      Offset(center.dx - 45, center.dy - 75),
      plusPaint,
    );
    
    // Plus sign 2
    canvas.drawLine(
      Offset(center.dx + 60, center.dy + 40),
      Offset(center.dx + 60, center.dy + 50),
      plusPaint,
    );
    canvas.drawLine(
      Offset(center.dx + 55, center.dy + 45),
      Offset(center.dx + 65, center.dy + 45),
      plusPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CelebrationPainter oldDelegate) {
    return oldDelegate.pulseScale != pulseScale;
  }
}

