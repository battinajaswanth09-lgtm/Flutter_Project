import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/responsive_scaffold.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      currentRoute: '/admin/reports',
      pageTitle: 'Academic Performance Analytics & Reports',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Institutional Academic Reports',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading consolidated academic report PDF...'), backgroundColor: AppColors.success),
                  );
                },
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Export Complete PDF'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Year-wise metric summary cards
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Annual Cohort Performance Matrix', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Comparative breakdown of students, attendance, and semester pass percentage', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 20),
                Table(
                  border: TableBorder.all(color: AppColors.border, borderRadius: BorderRadius.circular(8)),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(1.5),
                    4: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                      children: [
                        _th('Academic Cohort'),
                        _th('Total Strength'),
                        _th('Avg Attendance'),
                        _th('Pass Rate'),
                        _th('Accreditation Status'),
                      ],
                    ),
                    TableRow(children: [_td('1st Year (Batch 2025)'), _td('120 Students'), _td('88.2%'), _td('92.4%'), _td('Eligible')]),
                    TableRow(children: [_td('2nd Year (Batch 2024)'), _td('110 Students'), _td('84.1%'), _td('89.1%'), _td('Eligible')]),
                    TableRow(children: [_td('3rd Year (Batch 2023)'), _td('98 Students'), _td('82.5%'), _td('87.3%'), _td('Eligible')]),
                    TableRow(children: [_td('4th Year (Batch 2022)'), _td('92 Students'), _td('85.7%'), _td('94.0%'), _td('Graduation Ready')]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _th(String title) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
    );
  }

  Widget _td(String val) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(val, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
    );
  }
}

