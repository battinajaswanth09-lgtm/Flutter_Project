import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class PerformanceChartWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const PerformanceChartWidget({
    Key? key,
    this.title = 'Monthly Attendance & Performance Overview',
    this.subtitle = 'Average campus-wide trends over past 6 months',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final months = [
      {'month': 'May', 'attendance': 86, 'gpa': 82},
      {'month': 'Jun', 'attendance': 82, 'gpa': 80},
      {'month': 'Jul', 'attendance': 90, 'gpa': 88},
      {'month': 'Aug', 'attendance': 84, 'gpa': 85},
      {'month': 'Sep', 'attendance': 88, 'gpa': 89},
      {'month': 'Oct', 'attendance': 85, 'gpa': 86},
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Row(
                children: [
                  _legendItem('Attendance %', AppColors.primary),
                  const SizedBox(width: 16),
                  _legendItem('Pass Rate %', AppColors.success),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: months.map((m) {
                final attHeight = (m['attendance'] as int) * 1.5;
                final gpaHeight = (m['gpa'] as int) * 1.5;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 16,
                          height: attHeight,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 16,
                          height: gpaHeight,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      m['month'] as String,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      ],
    );
  }
}

