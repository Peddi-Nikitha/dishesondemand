import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../utils/theme_helper.dart';

/// Animated bar chart widget for earnings
class AnimatedBarChart extends StatefulWidget {
  final List<BarChartData> data;
  final String selectedMonth;

  const AnimatedBarChart({
    super.key,
    required this.data,
    required this.selectedMonth,
  });

  @override
  State<AnimatedBarChart> createState() => _AnimatedBarChartState();
}

class _AnimatedBarChartState extends State<AnimatedBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart animation when selected month changes
    if (oldWidget.selectedMonth != widget.selectedMonth) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = ThemeHelper.getPrimaryColor(context);
    final maxValue = widget.data.map((e) => e.total).reduce((a, b) => a > b ? a : b);

    // Calculate available height for bars (total height - padding - spacing - text height)
    // Account for actual constraints: Row has 168px (200 - 32 padding)
    // Column needs: bar + spacing(8) + text(~17-18) = 168px max
    // So max bar height = 168 - 8 - 18 - 2px buffer = 140px (to prevent 1px overflow)
    const double totalHeight = 200;
    const double verticalPadding = AppTheme.spacingM * 2; // top + bottom = 32px
    const double rowAvailableHeight = totalHeight - verticalPadding; // 168px
    const double spacingBetweenBarAndLabel = AppTheme.spacingS; // 8px
    const double textHeight = 18; // Text height with buffer
    const double safetyBuffer = 2; // 2px buffer to prevent rounding overflow
    const double maxBarHeight = rowAvailableHeight - spacingBetweenBarAndLabel - textHeight - safetyBuffer; // 140px

    return SizedBox(
      height: totalHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.data.map((barData) {
            final isSelected = barData.month == widget.selectedMonth;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bar - use SizedBox with fixed max height to prevent overflow
                    SizedBox(
                      height: maxBarHeight,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            final totalBarHeight = ((barData.total / maxValue) * maxBarHeight * _animation.value).clamp(0.0, maxBarHeight);
                            final bottomSegmentHeight = ((barData.bottomSegment / maxValue) * maxBarHeight * _animation.value).clamp(0.0, totalBarHeight);
                            final topSegmentHeight = (totalBarHeight - bottomSegmentHeight).clamp(0.0, maxBarHeight);
                            
                            return SizedBox(
                              width: double.infinity,
                              height: totalBarHeight,
                              child: Stack(
                                children: [
                                  // Bottom segment (darker)
                                  if (bottomSegmentHeight > 0)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: bottomSegmentHeight,
                                        decoration: BoxDecoration(
                                          color: primaryColor.withValues(alpha: 0.4),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(4),
                                            bottomRight: Radius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  // Top segment (brighter)
                                  if (topSegmentHeight > 0)
                                    Positioned(
                                      bottom: bottomSegmentHeight,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: topSegmentHeight,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              primaryColor,
                                              primaryColor.withValues(alpha: 0.6),
                                            ],
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    // Month label
                    Text(
                      barData.month,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected
                            ? ThemeHelper.getPrimaryColor(context)
                            : ThemeHelper.getTextSecondaryColor(context),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BarChartData {
  final String month;
  final double total;
  final double bottomSegment;

  BarChartData({
    required this.month,
    required this.total,
    required this.bottomSegment,
  });
}

