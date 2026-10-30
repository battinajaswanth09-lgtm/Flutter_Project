import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/status_badge.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final academic = Provider.of<AcademicProvider>(context);

    const double attendance = 88.5;
    const double cgpa = 8.75;
    final isShortage = attendance < 75.0;

    return ResponsiveScaffold(
      currentRoute: '/student/dashboard',
      pageTitle: 'Student Academic Portal',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Profile Header Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundImage: NetworkImage(
                    user?.avatar ??
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Alex Johnson',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Roll No: CSE-2023-042 • B.Tech Computer Science (Sem 5-A)',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Batch: 2023-2027 • Regular Student',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stat Cards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Overall Attendance',
                  value: '$attendance%',
                  icon: Icons.fact_check_rounded,
                  color: isShortage ? AppColors.danger : AppColors.success,
                  trend: isShortage ? 'Shortage (<75%)' : 'Eligible for Finals',
                  isPositive: !isShortage,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Cumulative CGPA',
                  value: '$cgpa',
                  icon: Icons.grade_rounded,
                  color: AppColors.primary,
                  trend: 'Rank #4 in Batch',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Tuition Fee Balance',
                  value: '\$0.00',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                  trend: 'All Dues Cleared',
                  isPositive: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Today's classes & Recent Results
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
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
                          const Text("Today's Timetable", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          TextButton(
                            onPressed: () => Navigator.of(context).pushReplacementNamed('/student/timetable'),
                            child: const Text('Full Week Schedule'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...academic.timetable.take(3).map((p) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: Text(p.startTime, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.primary)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.subjectName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                    Text('${p.subjectCode} • ${p.roomNumber} • Prof. ${p.facultyName}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Container(
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
                          const Text('Latest Exam Marks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          TextButton(
                            onPressed: () => Navigator.of(context).pushReplacementNamed('/student/results'),
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...academic.examResults.take(3).map((r) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.subjectName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                    Text('${r.marksObtained.toInt()} / ${r.maxMarks.toInt()} Marks', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(6)),
                                child: Text('Grade ${r.grade}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 12)),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

