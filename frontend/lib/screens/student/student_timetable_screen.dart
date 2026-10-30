import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';

class StudentTimetableScreen extends StatelessWidget {
  const StudentTimetableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final academic = Provider.of<AcademicProvider>(context);
    final periods = academic.timetable;

    return ResponsiveScaffold(
      currentRoute: '/student/timetable',
      pageTitle: 'My Class Timetable',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                const Text('Semester 5 - Section A (Weekly Timetable)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Classroom Location: Block C, Lecture Hall 301', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 20),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: periods.length,
                  separatorBuilder: (_, __) => const Divider(height: 20),
                  itemBuilder: (ctx, index) {
                    final p = periods[index];
                    return Row(
                      children: [
                        Container(
                          width: 85,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(p.startTime, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.primary)),
                              Text(p.endTime, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.subjectName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              const SizedBox(height: 2),
                              Text('${p.subjectCode} • Lecturer: ${p.facultyName}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
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
                          child: Text(p.roomNumber, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

