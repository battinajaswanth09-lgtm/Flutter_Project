import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/status_badge.dart';

class StudentAttendanceScreen extends StatelessWidget {
  const StudentAttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final academic = Provider.of<AcademicProvider>(context);
    final subjectAttendance = academic.studentAttendance;

    int totalHeld = 0;
    int totalAttended = 0;
    for (var s in subjectAttendance) {
      totalHeld += s.total;
      totalAttended += s.attended;
    }

    final overall = totalHeld > 0 ? (totalAttended / totalHeld * 100) : 100.0;
    final isShortage = overall < 75.0;

    return ResponsiveScaffold(
      currentRoute: '/student/attendance',
      pageTitle: 'My Attendance Status',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: overall / 100,
                        strokeWidth: 9,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(isShortage ? AppColors.danger : AppColors.success),
                      ),
                    ),
                    Text(
                      '${overall.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isShortage ? AppColors.danger : AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isShortage ? 'Attendance Shortage Alert!' : 'Attendance in Good Standing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isShortage ? AppColors.danger : AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isShortage
                          ? 'Your cumulative attendance has fallen below the mandatory 75% threshold. Please meet your faculty advisor.'
                          : 'You meet the minimum 75% attendance policy for semester end examinations.',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Classes Held: $totalHeld | Attended: $totalAttended | Absences: ${totalHeld - totalAttended}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Subject-wise Breakdown Table
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Subject-wise Attendance Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const Divider(height: 1),
                DataTable(
                  horizontalMargin: 20,
                  columnSpacing: 30,
                  columns: const [
                    DataColumn(label: Text('Course Subject', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Subject Code', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Conducted', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Attended', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Percentage', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Standing', style: TextStyle(fontWeight: FontWeight.w700))),
                  ],
                  rows: subjectAttendance.map((s) {
                    final low = s.percentage < 75.0;
                    return DataRow(
                      cells: [
                        DataCell(Text(s.subject, style: const TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(Text(s.code)),
                        DataCell(Text('${s.total}')),
                        DataCell(Text('${s.attended}')),
                        DataCell(
                          Text(
                            '${s.percentage}%',
                            style: TextStyle(fontWeight: FontWeight.w700, color: low ? AppColors.danger : AppColors.success),
                          ),
                        ),
                        DataCell(StatusBadge(status: low ? 'Shortage' : 'Satisfactory')),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
