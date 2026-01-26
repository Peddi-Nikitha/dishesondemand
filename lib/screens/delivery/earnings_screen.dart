import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/earnings_total_card.dart';
import '../../widgets/earnings_stat_card.dart';
import '../../widgets/animated_bar_chart.dart';
import '../../widgets/month_filter_button.dart';
import '../../widgets/earnings_shipment_item.dart';
import '../../widgets/delivery_bottom_nav_bar.dart';
import 'delivery_home_screen.dart';
import 'notifications_screen.dart';
import 'delivery_profile_screen.dart';
import 'pickup_task_screen.dart';
import 'delivery_completion_screen.dart';

/// Delivery driver earnings screen matching the exact design from screenshot
class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int _currentNavIndex = 1; // Earnings is index 1
  String _selectedMonth = 'Mar';

  // Bar chart data
  final List<BarChartData> _chartData = [
    BarChartData(month: 'Jan', total: 60, bottomSegment: 20),
    BarChartData(month: 'Feb', total: 80, bottomSegment: 30),
    BarChartData(month: 'Mar', total: 100, bottomSegment: 40),
    BarChartData(month: 'Apr', total: 70, bottomSegment: 25),
    BarChartData(month: 'May', total: 90, bottomSegment: 35),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingL,
                  AppTheme.spacingL,
                  AppTheme.spacingL,
                  AppTheme.spacingM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // My Earnings section
                    Text(
                      'My Earnings',
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    // Earnings cards row
                    Row(
                      children: [
                        // Total earnings card
                        Expanded(
                          flex: 2,
                          child: EarningsTotalCard(
                            label: 'Total',
                            amount: '\$3450.30',
                            changeText: '0.5% than last month',
                            isPositive: true,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        // Statistics cards
                        Expanded(
                          child: Column(
                            children: [
                              EarningsStatCard(
                                icon: Icons.grid_view,
                                iconColor: Colors.amber,
                                label: 'Total Delivery',
                                value: '1622',
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              EarningsStatCard(
                                icon: Icons.access_time,
                                iconColor: Colors.red,
                                label: 'On time Delivery',
                                value: '87%',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Profit Yearly section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: ThemeHelper.getTextPrimaryColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                const TextSpan(text: 'profit Yearly '),
                                TextSpan(
                                  text: '(28%)',
                                  style: AppTextStyles.headlineMedium.copyWith(
                                    color: ThemeHelper.getTextSecondaryColor(context),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Action buttons
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // Handle chart view
                              },
                              icon: Icon(
                                Icons.bar_chart,
                                color: ThemeHelper.getTextSecondaryColor(context),
                                size: 20,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: ThemeHelper.getSurfaceColor(context),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingS),
                            IconButton(
                              onPressed: () {
                                // Handle maximize
                              },
                              icon: Icon(
                                Icons.open_in_full,
                                color: ThemeHelper.getTextSecondaryColor(context),
                                size: 20,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: ThemeHelper.getSurfaceColor(context),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    // Month filters
                    Row(
                      children: [
                        MonthFilterButton(
                          month: 'Jan',
                          isSelected: _selectedMonth == 'Jan',
                          onTap: () => setState(() => _selectedMonth = 'Jan'),
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        MonthFilterButton(
                          month: 'Feb',
                          isSelected: _selectedMonth == 'Feb',
                          onTap: () => setState(() => _selectedMonth = 'Feb'),
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        MonthFilterButton(
                          month: 'Mar',
                          isSelected: _selectedMonth == 'Mar',
                          onTap: () => setState(() => _selectedMonth = 'Mar'),
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        MonthFilterButton(
                          month: 'Apr',
                          isSelected: _selectedMonth == 'Apr',
                          onTap: () => setState(() => _selectedMonth = 'Apr'),
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        MonthFilterButton(
                          month: 'May',
                          isSelected: _selectedMonth == 'May',
                          onTap: () => setState(() => _selectedMonth = 'May'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    // Animated bar chart
                    AnimatedBarChart(
                      data: _chartData,
                      selectedMonth: _selectedMonth,
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Recent Shipment section
                    Text(
                      'Recent Shipment',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    // Shipment list
                    EarningsShipmentItem(
                      label: 'Parcel Delivery',
                      origin: 'Lekki',
                      destination: 'Gbagada',
                      amount: '\$450.30',
                      status: 'Received',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DeliveryCompletionScreen(),
                          ),
                        );
                      },
                    ),
                    EarningsShipmentItem(
                      label: 'Parcel Delivery',
                      origin: 'Lekki',
                      destination: 'Gbagada',
                      amount: '\$450.30',
                      status: 'Received',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DeliveryCompletionScreen(),
                          ),
                        );
                      },
                    ),
                    EarningsShipmentItem(
                      label: 'Parcel Delivery',
                      origin: 'Lekki',
                      destination: 'Gbagada',
                      amount: '\$450.30',
                      status: 'Received',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DeliveryCompletionScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                  ],
                ),
              ),
            ),
            // Bottom Navigation Bar
            DeliveryBottomNavBar(
              currentIndex: _currentNavIndex,
              notificationCount: 2,
              onTap: (index) {
                if (index == 0) {
                  // Navigate back to Home screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const DeliveryHomeScreen(),
                    ),
                  );
                } else if (index == 1) {
                  // Already on Earnings screen
                  setState(() {
                    _currentNavIndex = index;
                  });
                } else if (index == 2) {
                  // Navigate to Pickup Task screen (truck icon)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PickupTaskScreen(),
                    ),
                  );
                } else if (index == 3) {
                  // Navigate to Notifications screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                } else if (index == 4) {
                  // Navigate to Profile screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DeliveryProfileScreen(),
                    ),
                  );
                } else {
                  setState(() {
                    _currentNavIndex = index;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

