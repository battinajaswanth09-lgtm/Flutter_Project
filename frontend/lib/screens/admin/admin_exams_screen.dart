import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/status_badge.dart';

class AdminExamsScreen extends StatelessWidget {
  const AdminExamsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      currentRoute: '/admin/exams',
      pageTitle: 'Examinations & Results Publishing',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Scheduled Examinations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Examination scheduler active'), backgroundColor: AppColors.primary),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Schedule New Exam'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Examination Title', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Exam Code', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Dates', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Semester', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('Semester 5 Mid-Term Examinations', style: TextStyle(fontWeight: FontWeight.w600))),
                      DataCell(Text('EXAM-SEM5-MID')),
                      DataCell(Text('Midterm')),
                      DataCell(Text('Oct 10 - Oct 22')),
                      DataCell(Text('Semester 5')),
                      DataCell(StatusBadge(status: 'Results Published')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Semester 5 End-Semester Finals', style: TextStyle(fontWeight: FontWeight.w600))),
                      DataCell(Text('EXAM-SEM5-FIN')),
                      DataCell(Text('Final')),
                      DataCell(Text('Dec 05 - Dec 18')),
                      DataCell(Text('Semester 5')),
                      DataCell(StatusBadge(status: 'Upcoming')),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

