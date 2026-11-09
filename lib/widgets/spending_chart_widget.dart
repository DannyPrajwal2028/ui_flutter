import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SpendingChartWidget extends StatefulWidget {
  const SpendingChartWidget({super.key});

  @override
  State<SpendingChartWidget> createState() => _SpendingChartWidgetState();
}

class _SpendingChartWidgetState extends State<SpendingChartWidget> {
  int _selectedDayIndex = 4; // Friday by default

  final List<Map<String, dynamic>> _weeklyData = const [
    {'day': 'Mon', 'amount': 1250.0},
    {'day': 'Tue', 'amount': 2400.0},
    {'day': 'Wed', 'amount': 850.0},
    {'day': 'Thu', 'amount': 3100.0},
    {'day': 'Fri', 'amount': 4650.0}, // Peak
    {'day': 'Sat', 'amount': 2200.0},
    {'day': 'Sun', 'amount': 1800.0},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final maxAmount = _weeklyData
        .map((d) => d['amount'] as double)
        .reduce((a, b) => a > b ? a : b);

    final selected = _weeklyData[_selectedDayIndex];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Spending Trends',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Selected: ${selected['day']} • ₹${(selected['amount'] as double).toStringAsFixed(0)}',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.accentNeon.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accentNeon.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_down_rounded, color: AppTheme.accentNeon, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '-8.4% this week',
                        style: TextStyle(
                          color: AppTheme.accentNeon,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bar Chart Area
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(_weeklyData.length, (index) {
                  final data = _weeklyData[index];
                  final heightRatio = (data['amount'] as double) / maxAmount;
                  final isSelected = index == _selectedDayIndex;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = index),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              height: 80 * heightRatio + 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: isSelected
                                      ? [AppTheme.accentPurple, AppTheme.accentViolet]
                                      : (isDark
                                          ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                                          : [const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)]),
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.accentPurple.withValues(alpha: 0.45),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['day'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected
                                    ? (isDark ? Colors.white : AppTheme.accentPurple)
                                    : (isDark ? Colors.grey[500] : Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

