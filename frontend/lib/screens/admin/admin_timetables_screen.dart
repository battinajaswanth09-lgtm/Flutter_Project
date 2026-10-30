import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';

class AdminTimetablesScreen extends StatelessWidget {
  const AdminTimetablesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final academic = Provider.of<AcademicProvider>(context);
    final periods = academic.timetable;

    return ResponsiveScaffold(
      currentRoute: '/admin/timetables',
      pageTitle: 'Class Timetable & Schedule',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Department of Computer Science - Semester 5 (Sec A)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text('Active Lecture Hall: Block C - LH 301', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Timetable period editor opened'), backgroundColor: AppColors.primary),
                  );
                },
                icon: const Icon(Icons.edit_calendar, size: 18),
                label: const Text('Update Schedule'),
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
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: periods.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (ctx, index) {
                final p = periods[index];
                return Row(
                  children: [
                    Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(p.startTime, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary)),
                          Text(p.endTime, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.subjectName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('${p.subjectCode} • Faculty: ${p.facultyName}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(p.roomNumber, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

