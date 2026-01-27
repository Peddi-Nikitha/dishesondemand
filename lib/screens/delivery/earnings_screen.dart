import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../utils/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../widgets/earnings_total_card.dart';
import '../../widgets/earnings_stat_card.dart';
import '../../widgets/animated_bar_chart.dart';
import '../../widgets/month_filter_button.dart';
import '../../widgets/delivery_bottom_nav_bar.dart';
import 'delivery_home_screen.dart';
import 'notifications_screen.dart';
import 'delivery_profile_screen.dart';
import 'pickup_task_screen.dart';

/// Delivery driver earnings screen matching the exact design from screenshot
class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int _currentNavIndex = 1; // Earnings is index 1
  String? _selectedMonthKey; // e.g. '01-2026'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: SafeArea(
        child: Consumer2<AuthProvider, OrderProvider>(
          builder: (context, authProvider, orderProvider, child) {
            final user = authProvider.user;

            if (user == null ||
                authProvider.userRole != AppConstants.roleDeliveryBoy) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: Text(
                    'Please sign in as a delivery partner to view earnings.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return StreamBuilder<List<OrderModel>>(
              stream: orderProvider.streamDeliveryBoyOrders(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      child: Text(
                        snapshot.error.toString(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final allOrders = snapshot.data ?? [];
                final deliveredOrders = allOrders
                    .where(
                        (o) => o.status == AppConstants.orderStatusDelivered)
                    .toList();

                final double totalEarnings = deliveredOrders.fold(
                  0.0,
                  (sum, o) => sum + o.total,
                );

                final int totalDeliveries = deliveredOrders.length;
                final double onTimePercent =
                    totalDeliveries == 0 ? 0 : 100.0; // placeholder

                // Group by month-year
                final Map<String, double> monthTotals = {};
                for (final order in deliveredOrders) {
                  final date = order.deliveredAt ?? order.createdAt;
                  final key =
                      '${date.month.toString().padLeft(2, '0')}-${date.year}';
                  monthTotals[key] =
                      (monthTotals[key] ?? 0) + order.total;
                }

                final months = monthTotals.keys.toList()
                  ..sort((a, b) {
                    DateTime parse(String key) {
                      final p = key.split('-');
                      return DateTime(int.parse(p[1]), int.parse(p[0]));
                    }

                    return parse(a).compareTo(parse(b));
                  });

                if (_selectedMonthKey == null && months.isNotEmpty) {
                  _selectedMonthKey = months.last;
                } else if (_selectedMonthKey != null &&
                    !months.contains(_selectedMonthKey)) {
                  _selectedMonthKey = months.isNotEmpty ? months.last : null;
                }

                final chartData = months
                    .map(
                      (m) => BarChartData(
                        month: m,
                        total: monthTotals[m] ?? 0,
                        bottomSegment: (monthTotals[m] ?? 0) * 0.4,
                      ),
                    )
                    .toList();

                // Month‑over‑month change
                String changeText = 'No previous data';
                bool isPositive = true;
                if (_selectedMonthKey != null && months.isNotEmpty) {
                  final idx = months.indexOf(_selectedMonthKey!);
                  final current = monthTotals[_selectedMonthKey!] ?? 0;
                  if (idx > 0) {
                    final prevKey = months[idx - 1];
                    final prev = monthTotals[prevKey] ?? 0;
                    if (prev <= 0) {
                      changeText = 'New period';
                      isPositive = true;
                    } else {
                      final diff = current - prev;
                      final percent = (diff / prev) * 100;
                      isPositive = percent >= 0;
                      changeText =
                          '${percent.toStringAsFixed(1)}% than previous month';
                    }
                  } else {
                    changeText = 'First month of activity';
                  }
                }

                return Column(
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
                            Text(
                              'My Earnings',
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: ThemeHelper.getTextPrimaryColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingL),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: EarningsTotalCard(
                                    label: 'Total',
                                    amount:
                                        '\$${totalEarnings.toStringAsFixed(2)}',
                                    changeText: changeText,
                                    isPositive: isPositive,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingM),
                                Expanded(
                                  child: Column(
                                    children: [
                                      EarningsStatCard(
                                        icon: Icons.grid_view,
                                        iconColor: Colors.amber,
                                        label: 'Total Delivery',
                                        value: '$totalDeliveries',
                                      ),
                                      const SizedBox(
                                          height: AppTheme.spacingM),
                                      EarningsStatCard(
                                        icon: Icons.access_time,
                                        iconColor: Colors.red,
                                        label: 'On time Delivery',
                                        value:
                                            '${onTimePercent.toStringAsFixed(0)}%',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingXL),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: AppTextStyles.headlineMedium
                                          .copyWith(
                                        color: ThemeHelper.getTextPrimaryColor(
                                            context),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        const TextSpan(
                                            text: 'Profit Overview '),
                                        TextSpan(
                                          text: totalEarnings > 0
                                              ? '(${changeText.split(' ').first})'
                                              : '(0%)',
                                          style: AppTextStyles.headlineMedium
                                              .copyWith(
                                            color: ThemeHelper
                                                .getTextSecondaryColor(
                                                    context),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingL),
                            if (months.isNotEmpty)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: months.map((monthKey) {
                                    final parts = monthKey.split('-');
                                    final m = int.parse(parts[0]);
                                    final y = parts[1];
                                    const labels = [
                                      'Jan',
                                      'Feb',
                                      'Mar',
                                      'Apr',
                                      'May',
                                      'Jun',
                                      'Jul',
                                      'Aug',
                                      'Sep',
                                      'Oct',
                                      'Nov',
                                      'Dec'
                                    ];
                                    final label =
                                        '${labels[m - 1]} $y'; // e.g. Jan 2026
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: AppTheme.spacingS),
                                      child: MonthFilterButton(
                                        month: label,
                                        isSelected:
                                            _selectedMonthKey == monthKey,
                                        onTap: () => setState(
                                            () => _selectedMonthKey =
                                                monthKey),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            else
                              Text(
                                'No earnings yet.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: ThemeHelper
                                      .getTextSecondaryColor(context),
                                ),
                              ),
                            const SizedBox(height: AppTheme.spacingL),
                            if (chartData.isNotEmpty &&
                                _selectedMonthKey != null)
                              AnimatedBarChart(
                                data: chartData,
                                selectedMonth: _selectedMonthKey!,
                              ),
                            const SizedBox(height: AppTheme.spacingXL),
                            Text(
                              'Recent Shipment',
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: ThemeHelper.getTextPrimaryColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingM),
                            if (deliveredOrders.isEmpty)
                              Text(
                                'No completed deliveries yet.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: ThemeHelper
                                      .getTextSecondaryColor(context),
                                ),
                              )
                            else
                              Column(
                                children: deliveredOrders
                                    .take(5)
                                    .map(
                                      (order) => ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 0,
                                          vertical: 4,
                                        ),
                                        title: Text(
                                          'Order #${order.orderNumber}',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                            color: ThemeHelper
                                                .getTextPrimaryColor(context),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          order.deliveryAddress.city,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                            color: ThemeHelper
                                                .getTextSecondaryColor(
                                                    context),
                                          ),
                                        ),
                                        trailing: Text(
                                          '\$${order.total.toStringAsFixed(2)}',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                            color: ThemeHelper
                                                .getTextPrimaryColor(context),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const DeliveryHomeScreen(),
                            ),
                          );
                        } else if (index == 1) {
                          setState(() {
                            _currentNavIndex = index;
                          });
                        } else if (index == 2) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PickupTaskScreen(),
                            ),
                          );
                        } else if (index == 3) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        } else if (index == 4) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DeliveryProfileScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

