import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/student_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/status_badge.dart';

class AdminAttendanceScreen extends StatelessWidget {
  const AdminAttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final allStudents = studentProvider.students;
    final shortageStudents = allStudents.where((s) => s.overallAttendance < 75.0).toList();

    return ResponsiveScaffold(
      currentRoute: '/admin/attendance',
      pageTitle: 'Campus Attendance Monitoring',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Average Attendance Rate',
                  value: '84.5%',
                  icon: Icons.trending_up,
                  color: AppColors.success,
                  trend: 'Satisfactory',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Shortage Alerts (< 75%)',
                  value: '${shortageStudents.length}',
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.danger,
                  trend: 'Action needed',
                  isPositive: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Classes Logged Today',
                  value: '38 Sessions',
                  icon: Icons.check_circle_outline,
                  color: AppColors.primary,
                  subtitle: '100% faculty submitted',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Students with Attendance Shortage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text('Automated alerts and notifications sent to guardians', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notice dispatched to guardians of students below 75% attendance.'), backgroundColor: AppColors.danger),
                        );
                      },
                      icon: const Icon(Icons.send, size: 16),
                      label: const Text('Send Warning Notices'),
                    ),
                  ],
                ),
                const Divider(height: 28),
                if (shortageStudents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No attendance shortages currently recorded!')),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      horizontalMargin: 12,
                      columnSpacing: 24,
                      columns: const [
                        DataColumn(label: Text('Student', style: TextStyle(fontWeight: FontWeight.w700))),
                        DataColumn(label: Text('Roll Number', style: TextStyle(fontWeight: FontWeight.w700))),
                        DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.w700))),
                        DataColumn(label: Text('Semester', style: TextStyle(fontWeight: FontWeight.w700))),
                        DataColumn(label: Text('Current %', style: TextStyle(fontWeight: FontWeight.w700))),
                        DataColumn(label: Text('Guardian', style: TextStyle(fontWeight: FontWeight.w700))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
                      ],
                      rows: shortageStudents.map((s) {
                        return DataRow(
                          cells: [
                            DataCell(Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text(s.rollNumber)),
                            DataCell(Text(s.departmentCode)),
                            DataCell(Text('Sem ${s.semester}')),
                            DataCell(Text('${s.overallAttendance}%', style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700))),
                            DataCell(Text('${s.guardianName} (${s.guardianPhone})')),
                            const DataCell(StatusBadge(status: 'Shortage')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
